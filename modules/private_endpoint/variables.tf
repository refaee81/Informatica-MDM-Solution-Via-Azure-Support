

variable "name" {
  type        = string
  description = "(Required) Specifies the name. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "The name of the resource group. Changing this forces a new resource to be created."
  default     = null
}

variable "location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  default     = null
}

variable "subnet_id" {}


variable "tags" {
  description = "(Required) map of tags for the deployment"
}
variable "subresource_names" {
  default = []
}

variable "private_dns" {
  default = {}
}

variable "private_service_connection_name" {
  default = {}
}


variable "private_connection_resource_id" {
  default = {}
}


variable "is_manual_connection" {
  default = {}
}


variable "dns_zone_group_name" {
  default = {}
}


variable "private_dns_zone_ids" {
  default = {}
}

variable "request_message" {
  default = {}
}

