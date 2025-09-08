variable "storage_data_scanner" {
  description = "Malware Scanning in Defender for Storage helps protect storage accounts, using Microsoft Defender Antivirus capabilities"
  type        = string
  default     = "/subscriptions/xxxxxxxxxxxxxxxxxxxxxxxxxxx/providers/Microsoft.Security/datascanners/StorageDataScanner"
} #added due to COE Req# RITM0031840 - Story#596042

variable "resource_group_name" {
  description = "(Required) The name of the resource group where to create the resource."
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}
variable "vnets" {
  default = {}
}
variable "private_endpoints" {
  default = {}
}
variable "resource_groups" {
  default = {}
}
variable "tags" {
  default = {}
}
variable "recovery_vaults" {
  default = {}
}
variable "private_dns" {
  default = {}
}

variable "sa_name" {
  description = "Name of storage account"
  type        = string
}

variable "settings" {
  type        = any
  description = "Settings mapped object for storage account"
}

variable "sa_snets" {
  type        = any
  description = "Subnets map object"
}

variable "private_endpoint_subnet" {
  type = string
}

variable "private_endpoint_subresources" {
  type = any
}

variable "identity_type" {
  type = string
}

variable "managed_identity_ids" {
  type = any
}

variable "datasource" {
  type = any
}

variable "environment" {
  type = string
}

variable "sa_sas_policy" {
  description = "Storage account sas rules"
  type        = bool
}

variable "sa_blob_versioning_enabled" {
  description = "Blob versioning value"
  type        = bool
}

variable "sa_private_link_access" {
  description = "Storage account private links"
  type        = bool
  default     = false
}

variable "subscription_id" {
  description = "The subscription ID"
  type        = string
}


#########################################
variable "network_rules" {
  type = object({
    bypass                     = optional(set(string), [])
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(set(string), [])
    virtual_network_subnet_ids = optional(set(string), [])
    private_link_access = optional(list(object({
      endpoint_resource_id = string
      endpoint_tenant_id   = optional(string)
    })))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }))
  })
  default = {}

    description = <<-EOT
 > Note the default value for this variable will block all public access to the storage account. If you want to disable all network rules, set this value to `null`.

 - `bypass` - (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`.
 - `default_action` - (Required) Specifies the default action of allow or deny when no other rules match. Valid options are `Deny` or `Allow`.
 - `ip_rules` - (Optional) List of public IP or IP ranges in CIDR Format. Only IPv4 addresses are allowed. Private IP address ranges (as defined in [RFC 1918](https://tools.ietf.org/html/rfc1918#section-3)) are not allowed.
 - `storage_account_id` - (Required) Specifies the ID of the storage account. Changing this forces a new resource to be created.
 - `virtual_network_subnet_ids` - (Optional) A list of virtual network subnet ids to secure the storage account.

 ---
 `private_link_access` block supports the following:
 - `endpoint_resource_id` - (Required) The resource id of the resource access rule to be granted access.
 - `endpoint_tenant_id` - (Optional) The tenant id of the resource of the resource access rule to be granted access. Defaults to the current tenant id.

 ---
 `timeouts` block supports the following:
 - `create` - (Defaults to 60 minutes) Used when creating the  Network Rules for this Storage Account.
 - `delete` - (Defaults to 60 minutes) Used when deleting the Network Rules for this Storage Account.
 - `read` - (Defaults to 5 minutes) Used when retrieving the Network Rules for this Storage Account.
 - `update` - (Defaults to 60 minutes) Used when updating the Network Rules for this Storage Account.
EOT
}