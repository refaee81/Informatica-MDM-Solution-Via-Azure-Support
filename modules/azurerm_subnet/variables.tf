variable "name" {
  description = "Name of the pre-existing vNet"
  default     = null
}

/* variable "prefix" {
  default = null
} */

variable "location" {}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Subnets map of objects"
  type        = any
}
variable "existing_subnets" {
  type    = map(string)
  default = {}
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)
}

variable "vnet_name" {
  type = string
  #default     = ""
  description = "Name of pre-exising vnet. Leave blank to have one created"
}

variable "azure_region_short" {
  description = "Region for the resource group in short format"
  type        = string
}

variable "environment" {
  description = "Application environment for which these assets are being created"
  type        = string
}

variable "appl" {
  type        = string
  description = "Name of the application"
}
