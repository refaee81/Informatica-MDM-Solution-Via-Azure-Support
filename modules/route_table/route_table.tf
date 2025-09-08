resource "azurerm_route_table" "route_table" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = var.tags
  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.route_table
    content {
      name                   = route.value.name
      address_prefix         = route.value.prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? (var.next_hop_in_dynamic_private_ip != null && var.next_hop_in_dynamic_private_ip != "null" && var.next_hop_in_dynamic_private_ip != "" ? var.next_hop_in_dynamic_private_ip : route.value.next_hop_in_ip_address) : null
    }
  }
}

  