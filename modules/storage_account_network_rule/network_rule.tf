# Network Rule for Storage Account

resource "azurerm_storage_account_network_rules" "nwrule" {
  storage_account_id = var.sa_storage_account_id
  default_action     = var.sa_default_action
  #ip_rules                   = var.sa_ip_rules //use this Rule for Public IPs to be whitelisted
  bypass                     = var.sa_bypass
  virtual_network_subnet_ids = var.sa_virtual_network_subnet_ids


}