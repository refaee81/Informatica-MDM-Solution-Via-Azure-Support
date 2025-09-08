
variable "tags" {
  description = "(Required) map of tags for the deployment"
}

variable "route_table" {
  description = "(Required) route table object to be created"

}
variable "route_table_name" {
  description = "(Required) name of the route table object to be created"
}


variable "next_hop_in_dynamic_private_ip" {
  description = "(Optional) dynamically passing private ip address which is an output of another tf resource or module, e.g. azure firewall"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the resource"
}

variable "location" {
  description = "(Requires) Location where to create the resource"
}
variable "disable_bgp_route_propagation" {
  description = "(Requires) enable or disable bgp route propagation"
  type        = bool
}