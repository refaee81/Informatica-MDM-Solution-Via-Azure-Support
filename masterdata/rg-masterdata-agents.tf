# Storage Resource Group creation
resource "azurerm_resource_group" "agents" {
  name     = "rg-${var.environment}-${var.appl}-agents-${var.azure_region_short}-01"
  location = var.azure_region
  tags     = var.dpe_tags
}


# Resource Group RBAC creation
module "agents_rg_rbac" {
  source = "../modules/rbacv2"

  depends_on = [
    azurerm_resource_group.agents
  ]

  for_each = try(var.resource_groups.agents.rbacs, {})

  scope     = azurerm_resource_group.agents.id
  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}


# Disk Encryption Set creation
module "des" {
  source = "../modules/des"

  depends_on = [
    azurerm_resource_group.agents,
    module.keyvault
  ]

  for_each = try(var.disk_encryption_sets, {})

  name                      = "des-${var.environment}-${var.appl}-${var.azure_region_short}-${each.value.name_suffix}"
  resource_group_name       = azurerm_resource_group.agents.name
  location                  = azurerm_resource_group.agents.location
  tags                      = merge(try(each.value.tags, null), var.dpe_tags)
  key_vault_id              = module.keyvault[lookup(each.value, "kv_instance", "kv1")].id
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  principal_id              = data.azurerm_client_config.current.object_id
  auto_key_rotation_enabled = each.value.auto_key_rotation_enabled
}

# Virtual Machine creation
module "virtual_machine" {
  source = "../modules/virtual_machine/virtual_machine"

  depends_on = [
    azurerm_resource_group.agents,
    module.keyvault,
    module.des,
    module.log_analytics_workspace,
    module.storage_account,
    module.action_group
  ]

  for_each = try(var.compute, {})

  resource_group_name             = azurerm_resource_group.agents.name
  location                        = azurerm_resource_group.agents.location
  tags                            = merge(try(each.value.tags, null), var.dpe_tags)
  vm_tags                         = var.vm_tags
  name                            = "vm-${var.environment}-${var.appl}-${var.azure_region_short}-${each.value.name_suffix}"
  nic_name                        = "nic-${var.environment}-${var.appl}-${var.azure_region_short}-${each.value.name_suffix}"
  admin_username                  = each.value.admin_username
  disk_encryption_set_id          = try(each.value.use_disk_encryption_set[0], false) == false ? null : module.des[each.value.use_disk_encryption_set[1]].id
  linux_distribution_name         = each.value.linux_distribution_name
  disable_password_authentication = each.value.disable_password_authentication
  virtual_machine_size            = each.value.virtual_machine_size
  disk_size_gb                    = each.value.disk_size
  availability_zone               = each.value.availability_zone
  managed_identity_type           = try(each.value.managed_identity_type, "SystemAssigned")
  managed_identity_ids            = try([module.managed_identity[each.value.managed_identity_id].id], null)
  network_interface_ids           = try(each.value.network_interface_ids, null)
  subnet_id                       = module.subnets.subnet[each.value.subnet]
  loganalytics_workspace_id       = ""#try(each.value.log_analytics_workspace, null) == null ? null : module.log_analytics_workspace[each.value.log_analytics_workspace].workspace_id #story 699719 Decommission of DEV LAW
  loganalytics_workspace_key      = ""#try(each.value.log_analytics_workspace, null) == null ? null : module.log_analytics_workspace[each.value.log_analytics_workspace].primary_shared_key #story 699719 Decommission of DEV LAW
  keyvault_id                     = module.keyvault[lookup(each.value, "kv_instance", "kv1")].id
  settings                        = try(each.value, {})
  storage_account_name            = try(module.storage_account[each.value.storage_account].name, null)
  storage_account_key             = try(module.storage_account[each.value.storage_account].primary_access_key, null)
  fileshare_name                  = try(each.value.fileshare_name, null)
  AGENT_NAME                      = var.AGENT_NAME
  AGENT_PASSWORD                  = var.AGENT_PASSWORD
  RUNTIME_GROUP                   = try(each.value.runtime_group, null)
  vm_alerts                       = try(each.value.alerts, null)
  all_alerts                      = try(var.alerts, {})
  action_groups                   = try(var.action_group, {})
  ag_rg                           = "rg-${var.environment}-${var.appl}-general-${var.azure_region_short}-01"
  environment                     = var.environment
  patch_assessment_mode           = var.patch_assessment_mode
  patch_mode                      = var.patch_mode
  bypass_platform_safety_checks   = var.bypass_platform_safety_checks

}
