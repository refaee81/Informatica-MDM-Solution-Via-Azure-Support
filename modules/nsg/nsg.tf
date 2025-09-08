## Create the network security groups

resource "azurerm_network_security_group" "nsg" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

# Security rules for the nsgs
resource "azurerm_network_security_rule" "security_rules" {
  count                   = length(var.security_rules)
  name                    = lookup(var.security_rules[count.index], "name", "default_rule_name")
  priority                = lookup(var.security_rules[count.index], "priority")
  direction               = lookup(var.security_rules[count.index], "direction", "Any")
  access                  = lookup(var.security_rules[count.index], "access", "Allow")
  protocol                = lookup(var.security_rules[count.index], "protocol", "*")
  source_port_range       = lookup(var.security_rules[count.index], "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges      = lookup(var.security_rules[count.index], "source_port_range", "*") == "*" ? null : split(",", var.security_rules[count.index].source_port_range)
  destination_port_ranges = split(",", replace(lookup(var.security_rules[count.index], "destination_port_range", "*"), "*", "0-65535"))

  source_address_prefix                      = lookup(var.security_rules[count.index], "source_application_security_group_ids", null) == null && lookup(var.security_rules[count.index], "source_address_prefixes", null) == null ? lookup(var.security_rules[count.index], "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(var.security_rules[count.index], "source_application_security_group_ids", null) == null ? lookup(var.security_rules[count.index], "source_address_prefixes", null) : null
  destination_address_prefix                 = lookup(var.security_rules[count.index], "destination_application_security_group_ids", null) == null && lookup(var.security_rules[count.index], "destination_address_prefixes", null) == null ? lookup(var.security_rules[count.index], "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(var.security_rules[count.index], "destination_application_security_group_ids", null) == null ? lookup(var.security_rules[count.index], "destination_address_prefixes", null) : null
  description                                = lookup(var.security_rules[count.index], "description", "Security rule for ${lookup(var.security_rules[count.index], "name", "default_rule_name")}")
  resource_group_name                        = azurerm_network_security_group.nsg.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  source_application_security_group_ids      = lookup(var.security_rules[count.index], "source_application_security_group_ids", null)
  destination_application_security_group_ids = lookup(var.security_rules[count.index], "destination_application_security_group_ids", null)
}

# module "diagnostic_settings_nsg" {
#   source = "../diagnostics"

#   profiles    = var.diagnostics_settings
#   resource_id = azurerm_network_security_group.nsg.id

#   for_each = try(var.settings.diagnostics_settings, {})

#   profile = each.value
# }
