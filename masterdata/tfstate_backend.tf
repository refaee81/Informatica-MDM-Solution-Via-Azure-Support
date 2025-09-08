# -------------------------------------------------------------------------------------------------------
# Azure Storage Account and Container for Masterdata Terraform state file
# -------------------------------------------------------------------------------------------------------
# A container organizes a set of blobs, similar to a directory in a file system. A storage account can 
# include an unlimited number of containers, and a container can store an unlimited number of blobs. 
# The container name must be lowercase.
#
# References:
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
# - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
# -------------------------------------------------------------------------------------------------------
# Resource Group, Storage Account and Container for DPE Terraform state file
# -------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-${var.environment}-mdm-tf-${var.azure_region_short}-01"
  location = var.azure_region
  tags     = var.dpe_tags
}

resource "azurerm_storage_account" "tfstate" {
  name                            = var.tf_sa_name
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = var.azure_region
  account_replication_type        = var.sa_replication_type
  account_tier                    = var.sa_account_tier
  min_tls_version                 = var.sa_min_tls_version
  allow_nested_items_to_be_public = false
  tags                            = var.dpe_tags

  blob_properties {
    delete_retention_policy {
      days = 31
    }
    container_delete_retention_policy {
      days = 31
    }
  }

  identity {
    type = var.sa_identity_type
  }

  lifecycle {
    prevent_destroy = true
  }

  network_rules {
    default_action             = var.sa_network_rules_default_action
    ip_rules                   = []
    virtual_network_subnet_ids = [var.vnet_snet_extnl_pipelines_vnet_containers_clouds2x]
    bypass                     = ["Logging", "Metrics", "AzureServices"]

    dynamic "private_link_access" {
      for_each = (var.sa_private_link_access == false) ? [] : [1]
      content {
        endpoint_resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/datascanners/storageDataScanner"
        endpoint_tenant_id   = data.azurerm_client_config.current.tenant_id
      }
    }
  }
  sas_policy {
    expiration_action = "Log"
    expiration_period = "0.12:00:00"
  }
}
#

resource "azurerm_storage_container" "tfstate" {
  name                  = var.tf_container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.tfstate]
}

# -------------------------------------------------------------------------------------------------------
# Role Based Access (RBAC)
# -------------------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "sa_tfstate_rbac_01" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_group.dp_platform_engineers.id
}

# read the tfstate container
resource "azurerm_role_assignment" "sa_tfstate_rbac_02" {
  scope                = "${azurerm_storage_account.tfstate.id}/blobServices/default/containers/${azurerm_storage_container.tfstate.name}"
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = data.azuread_group.dp_platform_engineers.id

  depends_on = [azurerm_storage_account.tfstate, azurerm_storage_container.tfstate]
}

# -------------------------------------------------------------------------------------------------------
# Resource Locks
# -------------------------------------------------------------------------------------------------------

resource "azurerm_management_lock" "tfstate" {
  name       = var.mgmt_lock_name_01
  scope      = azurerm_storage_account.tfstate.id
  lock_level = var.mgmt_lock_level_01
  notes      = var.mgmt_lock_notes_01

  depends_on = [azurerm_storage_account.tfstate]
}

