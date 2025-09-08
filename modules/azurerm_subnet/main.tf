resource "azurerm_subnet" "subnet" {

  for_each                                      = var.subnets
  name                                          = "snet-${var.environment}-${var.appl}-${each.key}-${var.azure_region_short}-01"
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = var.vnet_name
  address_prefixes                              = each.value.prefixes
  service_endpoints                             = each.value.service_endpoints
  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  dynamic "delegation" {
    for_each = each.value.service_delegations
    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

