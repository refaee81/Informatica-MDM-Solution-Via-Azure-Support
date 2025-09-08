# data "azurerm_virtual_machine" "azurevm" {
#   name                = "vmxx-xxxx-xxxc-01"
#   resource_group_name = "rg-xx-xxxx-xxx-01"
# }

# data "azurerm_virtual_machine" "azurevm_2" {
#   name                = "vm-xx-xxxx-xxxi-cc-02"
#   resource_group_name = "rg-pxx-xxxx-xxxe-cc-01"
#   depends_on          = [module.virtual_machine]
# }



#resource "azurerm_resource_group" "backup_rg_cc_1" {
#  name     = "AzureBackupRG_canadacentral_1"
#  location = var.azure_region
#  tags     = var.dpe_tags
#}

data "azurerm_virtual_machine" "azurevm" {
  for_each = toset(var.backup_enabled_vms)
  name                = each.key
  resource_group_name = azurerm_resource_group.agents.name
  depends_on          = [module.virtual_machine]
}


resource "azurerm_recovery_services_vault" "vault" {
  count = var.backup_enabled_vms != [] ? 1 : 0
  name                = "rsv-${var.environment}-masterdata-cc-01"
  location            = azurerm_resource_group.agents.location
  resource_group_name = azurerm_resource_group.agents.name
  sku                 = "Standard"
  cross_region_restore_enabled = true   
  immutability = "Unlocked"                   
  identity {
    type = "SystemAssigned"
  }
  public_network_access_enabled = false
  soft_delete_enabled           = true
  tags                          = var.dpe_tags
  lifecycle {
      ignore_changes = all
  }
}


resource "azurerm_backup_policy_vm" "rsv" {
  count = var.backup_enabled_vms != [] ? 1 : 0
  #name                = "bkpol-masterdata-vm-01"
  name                = "vm-std-daily-backup-policy"
  resource_group_name = azurerm_resource_group.agents.name
  recovery_vault_name = azurerm_recovery_services_vault.vault[0].name
  timezone            = "Eastern Standard Time"
  instant_restore_retention_days = 2

  backup {
    frequency = "Daily"
    time      = "23:00"
  }
  retention_daily {
    #count = 10
    count = 90
  }
  retention_weekly {
    count    = 5
    weekdays = ["Sunday"]
  }
  depends_on = [azurerm_recovery_services_vault.vault[0]]
  lifecycle {
      ignore_changes = all
  }
}


resource "azurerm_backup_protected_vm" "rsv" {
  for_each = toset(var.backup_enabled_vms)
  resource_group_name = azurerm_resource_group.agents.name
  recovery_vault_name = azurerm_recovery_services_vault.vault[0].name
  source_vm_id        = data.azurerm_virtual_machine.azurevm[each.key].id
  backup_policy_id    = azurerm_backup_policy_vm.rsv[0].id
  depends_on          = [
    azurerm_recovery_services_vault.vault[0],
    # TO BE REVERTED AFTER APPLY
    module.virtual_machine,
    module.keyvault,
    azurerm_resource_group.agents
    ]
  lifecycle {
    ignore_changes = all
  }
}

