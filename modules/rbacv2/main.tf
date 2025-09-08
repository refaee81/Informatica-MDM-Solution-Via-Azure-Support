
data "azuread_service_principal" "spn" {
  count        = lower(var.type) == "service_principal" ? 1 : 0
  display_name = var.principal
}

data "azuread_user" "user" {
  count               = lower(var.type) == "user" ? 1 : 0
  user_principal_name = var.principal
}

data "azuread_group" "group" {
  count        = lower(var.type) == "group" ? 1 : 0
  display_name = var.principal
}

resource "azurerm_role_assignment" "assignment" {
  for_each = var.role

  scope                = var.scope
  role_definition_name = each.value
  principal_id         = coalesce(try(data.azuread_service_principal.spn[0].object_id, ""), try(data.azuread_user.user[0].object_id, ""), try(data.azuread_group.group[0].object_id, ""))

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}
