# Container Module

resource "azurerm_storage_container" "stg" {
  name                  = var.sa_container_name
  storage_account_name  = var.storage_account_name
  container_access_type = try(var.sa_container_access_type, "private")
}

module "blob" {
  source = "../blob"

  for_each               = try(var.settings.upload_files_folder, null) == null ? toset([]) : toset(var.settings.upload_files_folder)
  folder                 = each.key
  environment            = var.environment
  storage_account_name   = var.storage_account_name
  storage_container_name = azurerm_storage_container.stg.name
}

module "blob_script" {
  source = "../blob_script"

  for_each               = try(var.settings.upload_scripts, null) == null ? toset([]) : toset(var.settings.upload_scripts)
  name                   = each.key
  storage_account_name   = var.storage_account_name
  storage_container_name = azurerm_storage_container.stg.name
  fileshare_name         = var.fileshare_settings[var.settings.fileshare].name
}

module "rbac_assignments" {
  source = "../../rbacv2"
  depends_on = [
    azurerm_storage_container.stg
  ]
  # scope = join("/", [var.settings.storageid, var.settings.name])
  scope = azurerm_storage_container.stg.resource_manager_id

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}
