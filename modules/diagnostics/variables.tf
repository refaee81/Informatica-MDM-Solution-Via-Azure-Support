variable "resource_id" {
  description = "(Required) Fully qualified Azure resource identifier for which you enable diagnostics."
}

variable "profiles" {

  validation {
    condition     = length(var.profiles) < 6
    error_message = "Maximun of 5 diagnostics profiles are supported."
  }
}

variable "profile" {
  type = any
}
