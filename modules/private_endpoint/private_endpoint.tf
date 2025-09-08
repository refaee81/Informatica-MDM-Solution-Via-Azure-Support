# Private Endpoint Module

resource "azurerm_private_endpoint" "pep" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = try(var.is_manual_connection, false)
    subresource_names              = var.subresource_names
    request_message                = try(var.request_message, null)
  }

  private_dns_zone_group {
    name                 = var.dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_ids
  }

}
