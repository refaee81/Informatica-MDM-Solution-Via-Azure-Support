# -------------------------------------------------------------------------------------------------------
# Azure Data Sources
# -------------------------------------------------------------------------------------------------------
# A data source is accessed via a special kind of resource known as a data resource, declared using 
# a data block.  A data block requests that Terraform read from a given data source and export the 
# result under the given local name.
#
# References:
# - https://www.terraform.io/language/data-sources
# -------------------------------------------------------------------------------------------------------
#Client Config
data "azurerm_client_config" "current" {
}

# Subscription
data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

data "azurerm_subscription" "environment" {
}

#Data for the Service Principal
data "azuread_service_principal" "sp-terraform-subscription" {
  display_name = var.service_principal_terraform_name
}

data "azuread_group" "dp_platform_engineers" {
  display_name = var.group_dp_platform_engineers
}

# Canada Central Virtual Network ID
data "azurerm_virtual_network" "vnet_hub_cc" {
  provider            = azurerm.hubcc_subscription
  name                = "vnet-xx-xxxx-xxxcc-01"
  resource_group_name = "rg-xx-xxxx-xxx-01"
}

data "azurerm_resource_group" "rg_hub_cc" {
  provider = azurerm.hubcc_subscription
  name     = "rg-xx-xxxx-xxxcc-01"
}

# Private DNS zone data for keyvault from the core hub (required for private endpoints creation)
data "azurerm_private_dns_zone" "dns_kv_hub_cc" {
  provider            = azurerm.hubcc_subscription
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.rg_hub_cc.name
}

# Private DNS zone data for storage account from the core hub (required for private endpoints creation)
data "azurerm_private_dns_zone" "dns_hub_cc" {
  for_each            = toset(["blob", "table", "queue", "dfs", "file"])
  provider            = azurerm.hubcc_subscription
  name                = "privatelink.${each.value}.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg_hub_cc.name
}

# Details on network resource group provided by CLZ team
data "azurerm_resource_group" "network" {
  name = var.vnet_rg_name
}
# Details on provided Virtual Network by CLZ team
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}
