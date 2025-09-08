resource "azurerm_log_analytics_workspace" "law" {
  name                               = var.name
  location                           = var.location
  resource_group_name                = var.resource_group_name
  daily_quota_gb                     = try(var.daily_quota_gb, null)
  internet_ingestion_enabled         = try(var.internet_ingestion_enabled, null)
  internet_query_enabled             = try(var.internet_query_enabled, null)
  reservation_capacity_in_gb_per_day = try(var.reservation_capacity_in_gb_per_day, null)
  sku                                = try(var.sku, "PerGB2018")
  retention_in_days                  = try(var.retention_in_days, 31)
  tags                               = try(var.tags, null)
}

module "rbac_assignments" {
  source = "../rbacv2"

  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
  scope = azurerm_log_analytics_workspace.law.id

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}
