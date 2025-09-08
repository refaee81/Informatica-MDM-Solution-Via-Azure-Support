resource "azurerm_user_assigned_identity" "msi" {
    name                        = var.name
    resource_group_name         = var.resource_group_name
    location                    = var.location

    tags                        = var.tags
}

resource "time_sleep" "propagate_to_azuread" {
  depends_on = [azurerm_user_assigned_identity.msi]

  create_duration = "30s"
}