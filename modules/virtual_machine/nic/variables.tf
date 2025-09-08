variable "location" {
  description = "(Required) Specifies the supported Azure location where to create the resource. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group to deploy the virtual machine"
}

variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}

variable "name" {
  description = "(Required) The name NIC."
  type        = string
}

variable "dns_servers" {
  description = "List of dns servers to use for network interface"
  default     = []
}
variable "enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Defaults to false"
  default     = false
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to true."
  default     = true
}

variable "internal_dns_name_label" {
  description = "The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network."
  default     = null
}

variable "ip_config_name" {
  description = "(Required) The name of NIC IP Configuration."
  type        = string
}

variable "primary" {
  description = "(Required) varibale to define NIC as primary or secondry."
  type        = string
}
variable "subnet_id" {
  description = "The id of the subnet to use in NIC"
  default     = ""
}

variable "private_ip_address_allocation_type" {
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "The Static IP Address which should be used. This is valid only when `private_ip_address_allocation` is set to `Static` "
  default     = null
}

