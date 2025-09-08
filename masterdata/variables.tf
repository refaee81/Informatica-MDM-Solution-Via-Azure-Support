
# Terraform Variables

# Input Variables serve as parameters for Terraform, so users can customize behavior without
# editing the source.
#
# References:
# - https://www.terraform.io/language/values/variables
# - https://www.terraform.io/language/values/locals
# - https://www.hashicorp.com/blog/terraform-sensitive-input-variables
# 

# ENVIRONMENT IDENTIFIERS

variable "tenantid" {
  description = "The tenant id from Azure"
  type        = string
  default     = "dxx-xxxx-xxxb80"
}

variable "subscription" {
  description = "Short name for the subscription"
  type        = string
  # default     = "test-xx-xxxx-xxx-01"
}

variable "subscription_id" {
  description = "The subscription ID"
  type        = string
  # default     = "b7xx-xxxx-xxxef8ce"
}

variable "environment" {
  description = "Application environment for which these assets are being created"
  type        = string
  # default     = "dev"
}

variable "appl" {
  description = "Application for which these assets are being created"
  type        = string
  # default     = "mdm"
}

variable "environment_sub" {
  description = "Subscription short name (test/prod) for which these assets are being created."
  type        = string
  # default     = "test"
}

variable "azure_region" {
  description = "Region for the resource group"
  type        = string
  # default     = "canadacentral"
}

variable "azure_region_short" {
  description = "Region for the resource group in short format"
  type        = string
  # default     = "cc"
}


# SERVICE PRINCIPAL

variable "service_principal_terraform_name" {
  description = "Name for the Service Principal for Terraform Pipelines"
  type        = string
  # default     = "sp-xx-xxxx-xxx-01"
}


# AZURE ACTIVE DIRECTORY

variable "group_dp_platform_engineers" {
  description = "Name for the Platform Engineers Group"
  type        = string
  default     = "dp-xx-xxxx-xxx-dmp"
}


# RESOURCE LOCKS

variable "mgmt_lock_name_01" {
  description = "Specifies the name of the Management Lock. Changing this forces a new resource to be created"
  type        = string
  default     = "DoNotDelete"
}

variable "mgmt_lock_level_01" {
  description = "Specifies the Level to be used for this Lock. Possible values are CanNotDelete and ReadOnly"
  type        = string
  default     = "CanNotDelete"
}

variable "mgmt_lock_notes_01" {
  description = "Specifies some notes about the lock"
  type        = string
  default     = "Locked by Terraform"
}


# RESOURCE GROUPS

variable "tf_resource_group" {
  description = "Resource Group for Terraform resources"
  type        = string
  default     = ""
}


# STORAGE ACCOUNT

/* variable "sa_account_prefix_001" {
  description = "Prefex for storage account"
  type        = string
  default     = "sa"
} */

variable "tf_sa_name" {
  description = "Terraform Storage Account Name"
  type        = string
}

# Use this Variable to create Container in SA
variable "tf_container_name" {
  description = "Terraform Storage Account Container Name"
  default     = {}
}

variable "sa_replication_type" {
  description = "Defines the type of replication to use for this storage account"
  type        = string
  default     = "" # LRS, GRS, RAGRS and ZRS
}

variable "sa_account_tier" {
  description = "Defines the Tier to use for this storage account"
  type        = string
  default     = "" # Standard, Premium
}

variable "sa_min_tls_version" {
  description = "The minimum supported TLS version for the storage account"
  type        = string
  default     = ""
}

variable "sa_identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Storage Account"
  type        = string
  default     = ""
}

variable "sa_network_rules_default_action" {
  description = "Specifies the default action of allow or deny when no other rules match"
  type        = string
  default     = ""
}

#variable "vnet_snet_extnl_pipelines_vnet_containers_cloudx" {
#  description = "ID of Subnet for CloudX agent pool resources"
#  type        = string
#  default     = ""
#}

variable "vnet_snet_extnl_pipelines_vnet_containers_clouds2x" {
  description = "ID of Subnet for Cloud2X agent pool resources"
  type        = string
  default     = ""
}


# RESOURCE TAGS

variable "dpe_tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

# ----------------------------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------------------------

# VNet and Subnet
variable "resource_group_name" {
  type        = string
  default     = null
  description = "Name of pre-exising resource group. Leave blank to have one created"
}

variable "vnet_name" {
  type        = string
  default     = null
  description = "Name of pre-exising vnet. Leave blank to have one created"
}

/* variable "prefix" {
  description = "A prefix used in the name for all cloud resources created by this script. The prefix string must start with lowercase letter and contain only lowercase alphanumeric characters and hyphen or dash(-), but can not start or end with '-'."
  type        = string

  validation {
    condition     = can(regex("^[a-z][-0-9a-z]*[0-9a-z]$", var.prefix)) && length(var.prefix) > 2 && length(var.prefix) < 21
    error_message = "ERROR: Value of 'prefix'\n * must start with lowercase letter and at most be 20 characters in length\n * can only contain lowercase letters, numbers, and hyphen or dash(-), but can't start or end with '-'."
  }
} */

variable "vnet_address_space" {
  type        = string
  description = "Address space for created vnet"
}

# variable "subnets" {
#   type = map(object({
#     prefixes                                      = list(string)
#     service_endpoints                             = list(string)
#     private_endpoint_network_policies_enabled     = bool
#     private_link_service_network_policies_enabled = bool
#     service_delegations = map(object({
#       name = string
#       actions = list(string)
#     }))
#   }))
# }

variable "subnets" {
  description = "Subnets map of objects"
  type        = any
}
variable "subnet_names" {
  type        = map(string)
  default     = {}
  description = "Map subnet usage roles to existing subnet names"
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

# Peering
variable "core_hub_vnet_id" {
  description = "Resource ID of vnet-core-hub-cc-01 in prod-core-01"
  type        = string
  default     = null
}

variable "hubcc_vnet" {
  type        = string
  default     = "/subscriptions/xx-xxxx-xxxre-hub-cc-01"
  description = "Hub vnet in canada central region"
}

variable "hubce_vnet" {
  type        = string
  default     = "/subscriptions/3xx-xxxx-xxxub-ce-01"
  description = "Hub vnet in canada east region"
}

variable "keyvaults" {
  description = "KeyVaults object map"
  type        = any
}
variable "route_tables" {
  description = "Route table object map"
  type        = any
}

variable "storage_accounts" {
  description = "Storage accounts object map"
  type        = any
}

variable "managed_identities" {
  type = any
}

# ----------------------------------------------------------------------------------------------
# Agents
# ----------------------------------------------------------------------------------------------

variable "admin_username" {
  description = "Username for the VMs used for SSH"
  type        = string
  default     = ""
}

variable "log_analytics" {
  type        = any
  description = "Project created LAWs"
  default     = {}
}

# ----------------------------------------------------------------------------------------------
# Network Watcher
# ----------------------------------------------------------------------------------------------

variable "AGENT_NAME" {
  type = string
}

variable "AGENT_PASSWORD" {
  type = string

  sensitive = true
}

variable "disk_encryption_sets" {
  type = any
}

variable "compute" {
  type = any
}

# ----------------------------------------------------------------------------------------------
# Resource Group
# ----------------------------------------------------------------------------------------------
variable "resource_groups" {
  description = "Resource Group objects map"
  type        = any
}

variable "vnet_rg_name" {
  description = "Pre-deployed RG name for networking components provided by CLZ team"
  type        = string
}
variable "action_group" {
  type = any
}
variable "alerts" {
  type = any
}

# ----------------------------------------------------------------------------------------------
# Backup Resource Group 
# ----------------------------------------------------------------------------------------------

variable "backup_enabled_vms" {
  type = any
  default = []
}

# new variable for virtual machine new updates Story#653281 
variable "patch_assessment_mode" {
  description = "The patch_assessment_mode for jump VM"
  type        = string
}
 
variable "patch_mode" {
  description = "The patch_mode for jump VM"
  type        = string
}

variable "vm_tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

variable "bypass_platform_safety_checks" {
  description = "bypass_platform_safety_checks_on_user_schedule_enabled"
  default        = false
}

variable "sa_private_link_access" {
  description = "Storage account private links"
  type        = bool
  default     = false
}

