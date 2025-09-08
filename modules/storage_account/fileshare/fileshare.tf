resource "azurerm_storage_share" "share" {
  name                 = try(var.settings.name, null)
  storage_account_name = var.storage_account_name
  quota                = try(var.settings.quota, 50)
  enabled_protocol     = try(var.settings.protocol, "SMB")
}

module "rbac_assignments" {
  source = "../../rbacv2"
  depends_on = [
    azurerm_storage_share.share
  ]
  # scope = join("/", [var.settings.storageid, var.settings.name])
  scope = azurerm_storage_share.share.resource_manager_id

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}
