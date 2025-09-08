resource "azurerm_key_vault_key" "des-key" {
  name         = "primary-des-key"
  key_vault_id = var.key_vault_id
  key_type     = "RSA"
  key_size     = 2048
  expiration_date         = "2026-01-25T15:13:08Z" #story668138
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "des-set" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  key_vault_key_id          = azurerm_key_vault_key.des-key.versionless_id
  auto_key_rotation_enabled = var.auto_key_rotation_enabled
  tags                      = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "rbac-disk" {
  scope                = "${var.key_vault_id}/keys/${azurerm_key_vault_key.des-key.name}"
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des-set.identity.0.principal_id
}


###########################################################################################################################################
