data "azurerm_client_config" "current" {} #added due to COE Req# RITM0031840 - Story#596042

# Storage Account Module
resource "random_id" "id" {
  byte_length = 1
}

resource "azurerm_storage_account" "stg_with_prevent_destroy" {
  count                     = var.environment == "prod" ? 1 : 0
  name                      = lookup(var.settings, "name", "${var.sa_name}${random_id.id.hex}")
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = try(var.settings.account_tier, "Standard")
  account_replication_type  = try(var.settings.account_replication_type, "LRS")
  account_kind              = try(var.settings.account_kind, "StorageV2")
  access_tier               = try(var.settings.access_tier, "Hot")
  enable_https_traffic_only = try(var.settings.enable_https_traffic_only, true) == false ? false : true
  #if using nfsv3_enabled, then https must be disabled
  min_tls_version                 = try(var.settings.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public = try(var.settings.allow_nested_items_to_be_public, false)
  is_hns_enabled                  = try(var.settings.is_hns_enabled, false)
  shared_access_key_enabled       = try(var.settings.shared_access_key_enabled, true)
  default_to_oauth_authentication = try(var.settings.default_to_oauth_authentication, false)

  # public_network_access_enabled   = try(var.settings.public_network_access_enabled, false)
  nfsv3_enabled            = try(var.settings.nfsv3_enabled, false)
  large_file_share_enabled = try(var.settings.large_file_share_enabled, null)
  tags                     = var.tags

  lifecycle {
    prevent_destroy = true
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  routing {
    publish_microsoft_endpoints = try(var.settings.publish_microsoft_endpoints, true)
  }

  dynamic "custom_domain" {
    for_each = try(var.settings.custom_domain, false) == false ? [] : [1]

    content {
      name          = try(var.settings.custom_domain.name, null)
      use_subdomain = try(var.settings.custom_domain.use_subdomain, false)
    }
  }

  dynamic "blob_properties" {
    for_each = ((var.settings.account_kind == "BlockBlobStorage" || var.settings.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled = try(var.sa_blob_versioning_enabled, false)#SAS New Policy#Story614156#old#versioning_enabled = try(var.settings.blob.versioning_enabled, false)
      #change_feed_enabled      = try(var.settings.blob.change_feed_enabled, false)
      #default_service_version  = try(var.settings.blob.default_service_version, "2020-06-12")
      #last_access_time_enabled = try(var.settings.blob.last_access_time_enabled, false)

      dynamic "cors_rule" {
        for_each = try(var.settings.cors_rule, false) == false ? [] : [1]

        content {
          allowed_headers    = var.storage_account.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.storage_account.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.storage_account.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.storage_account.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.storage_account.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = (var.settings.blob.delete_retention_days == 0 ? [] : [1])
        content {
          days = try(var.settings.blob.delete_retention_days, 7)
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.settings.container_delete_retention_days == 0 ? [] : [1])

        content {
          days = try(var.settings.container_delete_retention_days, 7)
        }
      }
    }
  }

  dynamic "sas_policy" {
    for_each = (var.sa_sas_policy == false) ? [] : [1]
    content {
      expiration_action = "Log"
      expiration_period = "0.12:00:00"
    }
  }

  dynamic "network_rules" {
    for_each = var.settings.network_rules == null ? [] : [var.settings.network_rules]
    content {
      bypass                     = try(var.settings.network_rules.bypass, "Logging", "Metrics", "AzureServices")
      default_action             = try(var.settings.network_rules.default_action, "Deny")
      ip_rules                   = try(var.settings.network_rules.ip_rules, null)
      virtual_network_subnet_ids = var.sa_snets
      #dynamic "private_link_access" {
      #  for_each = var.settings.network_rules.private_link_access ==null ? [] : var.network_rules.private_link_access
      #  content {
      #    endpoint_resource_id  = private_link_access.value.endpoint_resource_id
      #    endpoint_tenant_id    = private_link_access.value.endpoint_tenant_id
      #  }
      #}
    }
  }
  #sas_policy {
  #  expiration_action = "Log"
  #  expiration_period = "0.12:00:00"
  #}
}

resource "azurerm_storage_account" "stg_without_prevent_destroy" {
  count                     = var.environment != "prod" ? 1 : 0
  name                      = lookup(var.settings, "name", "${var.sa_name}${random_id.id.hex}")
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = try(var.settings.account_tier, "Standard")
  account_replication_type  = try(var.settings.account_replication_type, "LRS")
  account_kind              = try(var.settings.account_kind, "StorageV2")
  access_tier               = try(var.settings.access_tier, "Hot")
  enable_https_traffic_only = try(var.settings.enable_https_traffic_only, true) == false ? false : true
  #if using nfsv3_enabled, then https must be disabled
  min_tls_version                 = try(var.settings.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public = try(var.settings.allow_nested_items_to_be_public, false)
  is_hns_enabled                  = try(var.settings.is_hns_enabled, false)
  shared_access_key_enabled       = try(var.settings.shared_access_key_enabled, true)
  default_to_oauth_authentication = try(var.settings.default_to_oauth_authentication, false)

  # public_network_access_enabled   = try(var.settings.public_network_access_enabled, false)
  nfsv3_enabled            = try(var.settings.nfsv3_enabled, false)
  large_file_share_enabled = try(var.settings.large_file_share_enabled, null)
  tags                     = var.tags

#  lifecycle {
#    prevent_destroy = false
#  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  routing {
    publish_microsoft_endpoints = try(var.settings.publish_microsoft_endpoints, true)
  }

  dynamic "custom_domain" {
    for_each = try(var.settings.custom_domain, false) == false ? [] : [1]

    content {
      name          = try(var.settings.custom_domain.name, null)
      use_subdomain = try(var.settings.custom_domain.use_subdomain, false)
    }
  }

  dynamic "blob_properties" {
    for_each = ((var.settings.account_kind == "BlockBlobStorage" || var.settings.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled = try(var.sa_blob_versioning_enabled, false)#SAS New Policy#Story614156#old#versioning_enabled = try(var.settings.blob.versioning_enabled, false)
      #change_feed_enabled      = try(var.settings.blob.change_feed_enabled, false)
      #default_service_version  = try(var.settings.blob.default_service_version, "2020-06-12")
      #last_access_time_enabled = try(var.settings.blob.last_access_time_enabled, false)

      dynamic "cors_rule" {
        for_each = try(var.settings.cors_rule, false) == false ? [] : [1]

        content {
          allowed_headers    = var.storage_account.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.storage_account.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.storage_account.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.storage_account.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.storage_account.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = (var.settings.blob.delete_retention_days == 0 ? [] : [1])
        content {
          days = try(var.settings.blob.delete_retention_days, 7)
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.settings.container_delete_retention_days == 0 ? [] : [1])

        content {
          days = try(var.settings.container_delete_retention_days, 7)
        }
      }
    }
  }
  dynamic "sas_policy" {
    for_each = (var.sa_sas_policy == false) ? [] : [1]
    content {
      expiration_action = "Log"
      expiration_period = "0.12:00:00"
    }
  }

#  dynamic "network_rules" {
#    for_each = var.settings.network_rules == null ? [] : [var.settings.network_rules]
#    content {
#      bypass                     = try(var.settings.network_rules.bypass, "Logging", "Metrics", "AzureServices")
#      default_action             = try(var.settings.network_rules.default_action, "Deny")
#      ip_rules                   = try(var.settings.network_rules.ip_rules, null)
#      virtual_network_subnet_ids = var.sa_snets
#      #Private Link Access was added due to COE Req# RITM0031840 - Story#596042
#      private_link_access {
#        endpoint_resource_id = var.storage_data_scanner
#        endpoint_tenant_id   = data.azurerm_client_config.current.tenant_id
#        }
#      }
#    }
  dynamic "network_rules" {
    for_each = var.settings.network_rules == null ? [] : [var.settings.network_rules]
    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = var.sa_snets
      dynamic "private_link_access" {
        for_each = var.network_rules.private_link_access ==null ? [] : var.network_rules.private_link_access
        content {
          endpoint_resource_id  = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id    = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      network_rules[0].private_link_access
    ]
  }
}


# Module to Create Container in Storage Account#
module "container" {
  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy,
    module.fileshare
  ]

  source   = "./container"
  for_each = try(var.settings.containers, {})

  storage_account_name     = try(azurerm_storage_account.stg_with_prevent_destroy[0].name, azurerm_storage_account.stg_without_prevent_destroy[0].name)
  sa_container_access_type = lower(each.value.access_type)
  sa_container_name        = lower(each.value.name)
  settings                 = each.value
  environment              = var.environment
  fileshare_settings       = try(var.settings.fileshares, {})
}

# Module to Create FileShare in Storage Account
module "fileshare" {
  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy
  ]

  source   = "./fileshare"
  for_each = try(var.settings.fileshares, {})

  storage_account_name = try(azurerm_storage_account.stg_with_prevent_destroy[0].name, azurerm_storage_account.stg_without_prevent_destroy[0].name)
  settings             = each.value
}

# Module to Create Lifecyle Policy on Storage Account
module "management_policy" {

  source             = "./management_policy"
  for_each           = var.settings.management_policies
  storage_account_id = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)
  settings           = try(var.settings.management_policies, {})
}

# Module to assign RBAC roles for Storage Account
module "rbac_assignments" {
  source = "../rbacv2"

  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy
  ]
  scope = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}

# Private Endpoint for Storage Account
module "private_endpoint_sa" {
  source = "../private_endpoint"

  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy
  ]
  count = try(var.settings.private_endpoint_enabled, false) == false ? 0 : length(var.private_endpoint_subresources)

  name                            = "pep-${var.private_endpoint_subresources[count.index]}-${try(azurerm_storage_account.stg_with_prevent_destroy[0].name, azurerm_storage_account.stg_without_prevent_destroy[0].name)}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  subnet_id                       = var.private_endpoint_subnet
  tags                            = var.tags
  private_service_connection_name = "pl-${try(azurerm_storage_account.stg_with_prevent_destroy[0].name, azurerm_storage_account.stg_without_prevent_destroy[0].name)}"
  private_connection_resource_id  = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)
  subresource_names               = [var.private_endpoint_subresources[count.index]]
  is_manual_connection            = "false"
  request_message                 = null
  dns_zone_group_name             = "privatelink-${var.private_endpoint_subresources[count.index]}-core-windows-net"
  private_dns_zone_ids            = [for key, zone in var.datasource : zone.id if key == var.private_endpoint_subresources[count.index]]

}

# Diagnostic settings enablement
module "diagnostic_settings_sa" {
  source = "../diagnostics"

  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy
  ]
  profiles    = var.settings.diagnostics_settings
  resource_id = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)

  for_each = try(var.settings.diagnostics_settings, {})

  profile = each.value
}



module "sftp" {
  source = "./sftp"

  depends_on = [
    azurerm_storage_account.stg_with_prevent_destroy,
    azurerm_storage_account.stg_without_prevent_destroy,
    module.container
  ]

  count = try(var.settings.sftp.enabled, false) == false ? 0 : 1

  resource_id   = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)
  isSftpEnabled = try(var.settings.sftp.enabled, false)
  sshPassword   = try(var.settings.sftp.hasSshPassword, false)
  username      = try(var.settings.sftp.username, null)
  container     = try(var.settings.sftp.container, null)
  permissions   = try(var.settings.sftp.permissions, null)
}

