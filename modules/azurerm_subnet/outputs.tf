#  output "subnets" {
#   description = "The ids of subnets inside the vNet"
#   value       = local.subnets
# }

output "subnet" {
description = "The name of the subnet ids"
value = {for k, v in azurerm_subnet.subnet: k => v.id}
}