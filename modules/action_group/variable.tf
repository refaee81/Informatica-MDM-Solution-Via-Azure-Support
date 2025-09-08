variable "resource_group_name" {
  description = "Name of the existing resource group to deploy the virtual machine"
}

variable "ag_name" {
  description = "(Required) The name of the ag."
  type        = string
}

variable "short_name" {
  description = "(Required) The short name of the action group. This will be used in SMS messages"
  type        = string
}
variable "emails" {
  description = "(Required) The email address of the receiver"
  type        = any
}

variable "tags" {
  description = "(Optional) Tags for the resource"
  type        = any
}




