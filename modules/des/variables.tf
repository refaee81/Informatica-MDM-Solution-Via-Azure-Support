variable "name" {
  description = "Name of the encryption set"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the encryption set"
  type        = string
}

variable "location" {
  description = "Name of the encryption set"
  type        = string
}

variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}

variable "key_vault_id" {
  description = "Key Vault ID used for the DES module"
  type        = string
}

variable "tenant_id" {
  description = "Name of the encryption set"
  type        = string
}

variable "principal_id" {
  description = "Name of the encryption set"
  type        = string
}

variable "auto_key_rotation_enabled" {
  description = "Key autorotation switch"
  type        = bool
}
