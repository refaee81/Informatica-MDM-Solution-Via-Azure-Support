
#------------------------------------
#Alert Module
#------------------------------------
resource "azurerm_monitor_metric_alert" "alert" {
  name                = var.alert_name
  resource_group_name = var.resource_group_name
  scopes              = var.scopes
  tags                = var.tags

  dynamic "criteria" {
    for_each = var.alert_criteria
    content {
      metric_namespace = criteria.value.metric_namespace
      metric_name      = criteria.value.metric_name
      aggregation      = criteria.value.aggregation
      operator         = criteria.value.operator
      threshold        = criteria.value.threshold
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  lifecycle {
    /* ignore_changes = [
      tags
    ] */
  }
}
