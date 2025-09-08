variable "type" {
  type    = string
  default = "ssh"
}

variable "host" {
  type = string
}

variable "password" {
  type = string
}

variable "user" {
  type = string
}

variable "container" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "scripts" {
  type    = any
  default = {}
}
