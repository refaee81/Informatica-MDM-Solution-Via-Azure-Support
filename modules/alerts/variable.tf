variable "resource_group_name" {
  description = "Name of the existing resource group to deploy the virtual machine"
}

variable "alert_name" {
  description = "(Required) The name of the alert."
  type        = string
}

variable "scopes" {
  description = "(Required) A set of strings of resource IDs at which the metric criteria should be applied."
  type        = any
}

variable "alert_criteria" {
  description = "(Required) The name of the Metric Alert. Changing this forces a new resource to be created"
  type        = any
}

variable "action_group_id" {
  type = any
}

variable "tags" {
  description = "(Optional) Tags for the resource"
  type        = any
}
