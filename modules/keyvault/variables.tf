variable "keyvault_name" {
  description = "(Required) Name of the Azure KeyVault to be created"
}

variable "location" {
  description = "(Required) Location of the Azure KeyVault to be created"
}

variable "tags" {
  description = "(Required) Tags of the Azure KeyVault to be created"
}

variable "resource_group_name" {
  description = "(Required) Resource Group of the Azure KeyVault to be created"
}

variable "snets" {
  description = "subnets map object"  
}

variable "private_endpoint_subnet" {
  type = string
}

variable "private_dns_zone" {
  type = string
}

variable "settings" {
  type = any
}