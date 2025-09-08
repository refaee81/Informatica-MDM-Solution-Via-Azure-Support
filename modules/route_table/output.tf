output "object" {
  description = "Returns the full object of the created route table"
  value       = azurerm_route_table.route_table
}

output "id" {
  description = "Returns the ID of the created route table"
  value       = azurerm_route_table.route_table.id
}

output "name" {
  description = "Returns the name of the created route table"
  value       = azurerm_route_table.route_table.name
}