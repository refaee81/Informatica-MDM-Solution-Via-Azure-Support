resource "random_password" "value" {
  length           = var.config.length
  special          = var.config.special
  override_special = var.config.override_special
  min_numeric      = 3
  min_special      = 3
  min_upper        = 3
}

resource "azurerm_key_vault_secret" "secret" {

  name         = var.name
  value        = random_password.value.result
  key_vault_id = var.keyvault_id
  expiration_date = "2026-01-25T15:13:08Z" #Story#668138

  lifecycle {
    ignore_changes = [
      key_vault_id
    ]
  }
}

output "result" {
  value = random_password.value.result

  sensitive = true
}
