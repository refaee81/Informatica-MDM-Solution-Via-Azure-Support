variable "sa_container_name" {
  description = "Name of container"
  type        = string
}


variable "sa_container_access_type" {
  description = "Container access type"
  type        = string
}


variable "storage_account_name" {
  description = "Name of storage account"
  type        = string
}

variable "settings" {
  type = any
}

variable "environment" {
  type = string
}

variable "fileshare_settings" {
  type = any
}
