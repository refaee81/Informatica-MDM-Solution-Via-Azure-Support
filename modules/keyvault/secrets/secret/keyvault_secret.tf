resource "azurerm_key_vault_secret" "secret" {
  name         = var.name
  value        = var.value
  key_vault_id = var.keyvault_id
  expiration_date = "2026-01-25T15:13:08Z" #Story#668138
  lifecycle {
    ignore_changes = [
      key_vault_id
    ]
  }
}
