resource "azurerm_monitor_diagnostic_setting" "diagnostics" {

  name               = var.profile.name
  target_resource_id = var.resource_id
  storage_account_id = contains(try([tostring(var.profile.destination_type)], tolist(var.profile.destination_type)), "storage") ? try(var.profile.storage_account_id, null) : null


  log_analytics_workspace_id     = contains(try([tostring(var.profile.destination_type)], tolist(var.profile.destination_type)), "log_analytics") ? try(var.profile.log_analytics_resource_id, null) : null
  log_analytics_destination_type = contains(try([tostring(var.profile.destination_type)], tolist(var.profile.destination_type)), "log_analytics") ? try(var.profile.log_analytics_destination_type, null) : null

  dynamic "log" {
    for_each = lookup(var.profile.categories, "log", {})
    content {
      category = log.value[0]
      enabled  = log.value[1]

      dynamic "retention_policy" {
        for_each = length(log.value) > 2 ? [1] : []
        content {
          enabled = log.value[2]
          days    = log.value[3]
        }
      }
    }
  }

  dynamic "metric" {
    for_each = lookup(var.profile.categories, "metric", {})
    content {
      category = metric.value[0]
      enabled  = metric.value[1]

      dynamic "retention_policy" {
        for_each = length(metric.value) > 2 ? [1] : []
        content {
          enabled = metric.value[2]
          days    = metric.value[3]
        }
      }
    }
  }
}

