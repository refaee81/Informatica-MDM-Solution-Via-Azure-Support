
variable "settings" {}

variable "storage_account_id" {
  description = "Id of Storage Account"
  type        = string
}

variable "sa_management_policies" {
  description = "Storage account lifecycle policy"
  #type        = map(string)
  default = {}
}