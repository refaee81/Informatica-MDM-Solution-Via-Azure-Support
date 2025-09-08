variable "sa_storage_account_id" {
  description = "(Required) The Id of storage account."
  type        = string
}


variable "sa_virtual_network_subnet_ids" {
  description = "Storage account subnet ids for network rule"
  type        = list(string)
}


variable "sa_bypass" {
  description = "Storage account subnet ids for network rule"
  type        = list(string)
}


variable "sa_default_action" {
  description = "(Required) The Id of storage account."
  type        = string
}