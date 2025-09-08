variable "name" {
  type = string
}

variable "location" {}
variable "resource_group_name" {}
variable "tags" {}
variable "daily_quota_gb" {
  type = any
}

variable "internet_ingestion_enabled" {
  type = any
}

variable "internet_query_enabled" {
  type = any
}

variable "reservation_capacity_in_gb_per_day" {
  type = any
}

variable "sku" {
  type = any
}

variable "retention_in_days" {
  type = any
}

variable "settings" {
  type = any
}
