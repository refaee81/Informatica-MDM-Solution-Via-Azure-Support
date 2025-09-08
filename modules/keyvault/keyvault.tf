data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "keyvault" {

  name                            = var.keyvault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = try(var.settings.sku_name, "standard")
  tags                            = var.tags
  enabled_for_deployment          = try(var.settings.enabled_for_deployment, true)
  enabled_for_disk_encryption     = try(var.settings.enabled_for_disk_encryption, true)
  enabled_for_template_deployment = try(var.settings.enabled_for_template_deployment, true)
  purge_protection_enabled        = try(var.settings.purge_protection_enabled, false)
  soft_delete_retention_days      = try(var.settings.soft_delete_retention_days, 30)
  enable_rbac_authorization       = try(var.settings.enable_rbac_authorization, true)

  dynamic "network_acls" {
    for_each = var.settings.network_acl == null ? [] : [var.settings.network_acl]
    content {
      bypass                     = try(var.settings.network_acl.bypass, "AzureServices")
      default_action             = try(var.settings.network_acl.default_action, "Deny")
      ip_rules                   = try(var.settings.network_acl.ip_rules, null)
      virtual_network_subnet_ids = var.snets
    }
  }

  dynamic "access_policy" {

    for_each = try(var.settings.enable_rbac_authorization, true) == false ? toset([data.azurerm_client_config.current.object_id]) : []
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
      key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"]
      secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
      storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
    }
  }
  dynamic "access_policy" {

    for_each = try(var.settings.enable_rbac_authorization, true) == false ? try(var.settings.access_policies, null) : []
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = try(access_policy.value.object_id)
      certificate_permissions = try(access_policy.value.certificate_permissions, null)
      key_permissions         = try(access_policy.value.key_permissions, null)
      secret_permissions      = try(access_policy.value.secret_permissions, null)
      storage_permissions     = try(access_policy.value.storage_permissions, null)
    }
  }

  lifecycle {
    ignore_changes = [
      tenant_id
    ]
  }
}

module "rbac_assignments" {
  source = "../rbacv2"

  scope = azurerm_key_vault.keyvault.id

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}

# Private Endpoint for KeyVault
module "private_endpoint_kv" {
  source = "../private_endpoint"

  count = try(var.settings.private_endpoint_enabled, false) == false ? 0 : 1

  name                            = replace(var.keyvault_name, "kv-", "pep-kv-")
  location                        = var.location
  resource_group_name             = var.resource_group_name
  subnet_id                       = var.private_endpoint_subnet
  tags                            = var.tags
  private_service_connection_name = replace(var.keyvault_name, "kv-", "pl-kv-")
  private_connection_resource_id  = azurerm_key_vault.keyvault.id
  subresource_names               = ["vault"]

  is_manual_connection = "false"
  request_message      = null
  dns_zone_group_name  = "privatelink-vaultcore-azure-net"
  private_dns_zone_ids = [var.private_dns_zone]
}

module "diagnostic_settings_kv" {
  source = "../diagnostics"
  # profiles variable is used for validation of number of diagnostic settings per resource (limit is 5)
  profiles    = var.settings.diagnostics_settings
  resource_id = azurerm_key_vault.keyvault.id

  for_each = try(var.settings.diagnostics_settings, {})

  profile = each.value
}

# Adding secrets
module "secret" {
  source = "./secrets/secret"

  for_each = try(var.settings.secrets, {})

  keyvault_id = azurerm_key_vault.keyvault.id
  name        = each.key
  value       = each.value
}
