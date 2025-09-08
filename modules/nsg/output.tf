output "name" {
  value = azurerm_network_security_group.nsg.name
}

output "id" {
  value = azurerm_network_security_group.nsg.id
}

# output "id" {
# description = "The list of the nsg ids"
# value = {for k, v in azurerm_network_security_group.nsg: k => v.id}
# }