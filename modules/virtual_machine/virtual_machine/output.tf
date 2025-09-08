# output "win_id" {
#   value = azurerm_windows_virtual_machine.win_vm[0].id
# }

output "linux_id" {
  value = azurerm_linux_virtual_machine.linux_vm.id
}

output "managed_identity_object_id" {
  value = azurerm_linux_virtual_machine.linux_vm.identity.0.principal_id
}

# Required for the file provisioner
output "private_ip_address" {
  value = azurerm_linux_virtual_machine.linux_vm.private_ip_address
}

output "name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}
