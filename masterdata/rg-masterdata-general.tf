# --------------------------------------------------------------------------------------------------------------------------
# This Terraform configuration file defines the resource group created for the MDM environment spoke general components like
# KeyVaults and Storage Accounts.
# ---------------------------------------------------------------------------------------------------------------------------


# General Resource Group creation
resource "azurerm_resource_group" "general" {
  # Resource group name is generated predictably using variables supplied
  name     = "rg-${var.environment}-${var.appl}-general-${var.azure_region_short}-01"
  location = var.azure_region
  tags     = var.dpe_tags
}

# Resource Group RBAC creation
module "general_rg_rbac" {
  source = "../modules/rbacv2"

  depends_on = [
    azurerm_resource_group.general
  ]

  for_each = try(var.resource_groups.general.rbacs, {})

  scope     = azurerm_resource_group.general.id
  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}


# User Assigned Identity creation
module "managed_identity" {
  source = "../modules/managed_identity"

  depends_on = [
    azurerm_resource_group.general
  ]

  for_each = try(var.managed_identities, {})

  name                = each.value.name
  location            = azurerm_resource_group.general.location
  resource_group_name = azurerm_resource_group.general.name
  tags                = merge(try(each.value.tags, null), var.dpe_tags)
}


# KeyVaults creation
module "keyvault" {
  source = "../modules/keyvault"

  depends_on = [
    module.managed_identity,
    azurerm_resource_group.general,
    module.subnets
  ]

  for_each = try(var.keyvaults, {})

  keyvault_name       = "kv-${var.environment}-${var.appl}-${var.azure_region_short}-${format("%02d", index(keys(var.keyvaults), each.key) + 1)}"
  location            = azurerm_resource_group.general.location
  resource_group_name = azurerm_resource_group.general.name
  # settings contains the whole object map for each keyvault instance. This approach eliminates the need to create multiple variables in the module
  settings                = each.value
  tags                    = merge(try(each.value.tags, null), var.dpe_tags)
  private_dns_zone        = data.azurerm_private_dns_zone.dns_kv_hub_cc.id
  private_endpoint_subnet = lookup(each.value, "private_endpoint_enabled", false) ? module.subnets.subnet[lookup(each.value, "private_endpoint_subnet", "")] : ""
  snets                   = try(each.value.network_acl.virtual_network_subnets, null) == null ? [var.vnet_snet_extnl_pipelines_vnet_containers_clouds2x] : concat([for snet in each.value.network_acl.virtual_network_subnets : try(module.subnets.subnet[snet], [])], [var.vnet_snet_extnl_pipelines_vnet_containers_clouds2x])

}


#  Storage Accounts creation
module "storage_account" {
  source = "../modules/storage_account"

  depends_on = [
    module.managed_identity,
    azurerm_resource_group.general
  ]

  for_each = try(var.storage_accounts, {})

  sa_name                       = lower("sa${var.environment}${var.appl}${var.azure_region_short}")
  location                      = azurerm_resource_group.general.location
  resource_group_name           = azurerm_resource_group.general.name
  sa_snets                      = try(each.value.network_rules.virtual_network_subnets, null) == null ? [var.vnet_snet_extnl_pipelines_vnet_containers_clouds2x] : concat([for snet in each.value.network_rules.virtual_network_subnets : try(module.subnets.subnet[snet], [])], [var.vnet_snet_extnl_pipelines_vnet_containers_clouds2x])
  private_endpoint_subnet       = lookup(each.value, "private_endpoint_enabled", false) ? module.subnets.subnet[lookup(each.value, "private_endpoint_subnet", "")] : ""
  private_endpoint_subresources = lookup(each.value, "private_endpoint_subresources", ["blob"])
  tags                          = merge(try(each.value.tags, null), var.dpe_tags)
  identity_type                 = try(each.value.identity_type, "SystemAssigned")
  managed_identity_ids          = try([module.managed_identity[each.value.managed_identity_id].id], null)
  settings                      = each.value
  datasource                    = data.azurerm_private_dns_zone.dns_hub_cc
  environment                   = var.environment
  sa_sas_policy                 = "true"
  sa_blob_versioning_enabled    = "false"
  sa_private_link_access = var.sa_private_link_access
  subscription_id        = var.subscription_id
}

# Log Analytics Workspace creation
module "log_analytics_workspace" {
  source = "../modules/log_analytics"

  depends_on = [
    azurerm_resource_group.general
  ]

  for_each = try(var.log_analytics, {})

  name                               = try(each.value.name, "law-${var.environment}-${var.appl}-${var.azure_region_short}-${format("%02d", index(keys(var.log_analytics), each.key) + 1)}")
  location                           = azurerm_resource_group.general.location
  resource_group_name                = azurerm_resource_group.general.name
  daily_quota_gb                     = lookup(each.value, "daily_quota_gb", null)
  internet_ingestion_enabled         = lookup(each.value, "internet_ingestion_enabled", null)
  internet_query_enabled             = lookup(each.value, "internet_query_enabled", null)
  reservation_capacity_in_gb_per_day = can(each.value.reservation_capcity_in_gb_per_day) || can(each.value.reservation_capacity_in_gb_per_day) ? try(each.value.reservation_capcity_in_gb_per_day, each.value.reservation_capacity_in_gb_per_day) : null
  sku                                = lookup(each.value, "sku", "PerGB2018")
  retention_in_days                  = lookup(each.value, "retention_in_days", 31)
  tags                               = merge(try(each.value.tags, null), var.dpe_tags)
  settings                           = each.value
}

module "action_group" {
  source = "../modules/action_group"

  for_each = try(var.action_group, {})

  short_name          = each.value.short_name
  resource_group_name = azurerm_resource_group.general.name
  ag_name             = "${each.value.ag_name}-${var.environment}"
  emails              = each.value.emails
  tags                = merge(try(each.value.tags, null), var.dpe_tags)
}
