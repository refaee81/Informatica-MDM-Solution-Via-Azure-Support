# Azure Network resources

# This Terraform configuration file defines the resource group created for the MDM environment spoke 
# networking components.
#
# Resources defined:
# - Virtual network(s) (VNet)
# - Subnet(s)
# - VNet Peering
# TBD -------------------------------------------------------------------------
# - NSGs, NSG Subnet association
# - Route Table, Subnet Route Table associations
# - Private EndPoints (DFS, blob, Queue, SQL Server, Key Vaults)
# - Private DNS Zones (DFS, blob, Queue, Database, Key Vault, edc.ca)
# - Private DNS zone Vnet Links (DFS, blob, Queue, SQL Server, Key Vault, edc.ca)
# - Private DNS A Record (DFS, blob, Queue, SQL Server, Key Vault, edc.ca)
# - Diagnostic Settings for resources
# /TBD -------------------------------------------------------------------------
#
# References:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

# Assign Resource Group RBAC
module "network_rg_rbac" {
  source = "../modules/rbacv2"

  for_each = try(var.resource_groups.network.rbacs, {})

  scope     = data.azurerm_resource_group.network.id
  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}

# Subnets creation (Vnet must be present). This is the only module that has foreach loop embedded into module. It came this way
# so ideally foreach loop needs to be moved out to this level and have module deploying a single entity
module "subnets" {
  source = "../modules/azurerm_subnet"

  resource_group_name = data.azurerm_resource_group.network.name
  location            = var.azure_region
  vnet_name           = data.azurerm_virtual_network.vnet.name
  azure_region_short  = var.azure_region_short
  tags                = var.dpe_tags
  subnets             = var.subnets
  appl                = var.appl
  environment         = var.environment
}


# Network Security Groups
module "nsg" {
  source = "../modules/nsg"

  for_each = var.subnets

  resource_group = data.azurerm_resource_group.network.name
  location       = data.azurerm_resource_group.network.location
  tags           = merge(try(each.value.tags, null), var.dpe_tags)
  security_rules = each.value.nsg.rules
  # diagnostic_settings = each.value.nsg.diagnostic_settings
  security_group_name = "nsg-${var.environment}-${var.appl}-${each.key}-${var.azure_region_short}"
}

# Associate subnet with network security group. 
resource "azurerm_subnet_network_security_group_association" "agents_nsg_associate" {

  depends_on = [
    module.subnets,
    module.nsg
  ]

  for_each = var.subnets

  subnet_id                 = module.subnets.subnet[each.key]
  network_security_group_id = module.nsg[each.key].id
}



# Route Tables
module "route_table" {
  source = "../modules/route_table"

  for_each = var.route_tables

  route_table_name              = "rt-${var.environment}-${var.appl}-${var.azure_region_short}-01"
  resource_group_name           = data.azurerm_resource_group.network.name
  location                      = data.azurerm_resource_group.network.location
  disable_bgp_route_propagation = true
  tags                          = merge(try(each.value.tags, null), var.dpe_tags)
  route_table                   = var.route_tables[each.key]
}

# Associate subnet with route table. 
resource "azurerm_subnet_route_table_association" "rt_associate" {

  depends_on = [
    module.subnets,
    module.route_table
  ]

  for_each = var.subnets

  subnet_id      = module.subnets.subnet[each.key]
  route_table_id = module.route_table[each.value.route_table].id
}



# Deploy Private Links
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {

  # conditional run of resource creation based on region
  count = var.environment == "prod" ? 0 : 1

  provider              = azurerm.hubcc_subscription
  name                  = "dnsl-${var.environment}-${var.appl}-${var.azure_region_short}-01"
  resource_group_name   = data.azurerm_resource_group.rg_hub_cc.name
  private_dns_zone_name = data.azurerm_private_dns_zone.dns_kv_hub_cc.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = "true"
  tags                  = var.dpe_tags
}
