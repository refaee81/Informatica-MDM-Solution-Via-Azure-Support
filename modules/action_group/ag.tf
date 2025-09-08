#------------------------------------
# Action Group Module
#------------------------------------
resource "azurerm_monitor_action_group" "ag" {
  name                = var.ag_name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.emails
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email_address
    }
  }

  lifecycle {
    /* ignore_changes = [
      tags
    ] */
  }
}
