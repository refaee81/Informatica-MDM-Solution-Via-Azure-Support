// validate code for security best practices

data "azurerm_monitor_action_group" "ag_group" {
  for_each = length(try(var.action_groups, {})) > 0 ? var.action_groups : {}

  resource_group_name = var.ag_rg
  name                = "${each.value.ag_name}-${var.environment}"
}


# Cloud Init

data "template_file" "cloud_init" {
  template = file(abspath("../scripts/cloud-init.yaml"))
  vars = {
    username  = var.AGENT_NAME
    password  = var.AGENT_PASSWORD
    group     = var.RUNTIME_GROUP
    adminuser = var.admin_username
  }
}

data "template_file" "disk" {
  template = file(abspath("../scripts/disk.sh"))
}

data "template_file" "mdmservice" {
  template = file(abspath("../scripts/service.sh"))
  vars = {
    adminuser = var.admin_username
  }
}

data "cloudinit_config" "cloud_init" {
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "01-disk.sh"
    content      = data.template_file.disk.rendered
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "02-mdmservice.sh"
    content      = data.template_file.mdmservice.rendered
  }
}


# Linux Virutal machine Module

resource "azurerm_linux_virtual_machine" "linux_vm" {

  depends_on = [
    module.dynamic_secret, module.nic
  ]

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_username
  admin_password                  = module.dynamic_secret.result
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = [module.nic.id]
  source_image_id                 = var.source_image_id
  provision_vm_agent              = var.provision_vm_agent
  allow_extension_operations      = var.allow_extension_operations
  dedicated_host_id               = var.dedicated_host_id
  custom_data                     = data.cloudinit_config.cloud_init.rendered
  availability_set_id             = var.availability_set_id
  encryption_at_host_enabled      = var.enable_encryption_at_host
  proximity_placement_group_id    = var.proximity_placement_group_id
  zone                            = var.availability_zone
  patch_assessment_mode           = var.patch_assessment_mode
  patch_mode                      = var.patch_mode 
  #tags                            = var.tags
  tags                            = merge(var.tags, var.vm_tags)
  bypass_platform_safety_checks_on_user_schedule_enabled = var.bypass_platform_safety_checks
        

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key_data == null ? tls_private_key.rsa[0].public_key_openssh : file(var.admin_ssh_key_data)
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_id != null ? [] : [1]
    content {
      publisher = var.custom_image != null ? var.custom_image["publisher"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["publisher"]
      offer     = var.custom_image != null ? var.custom_image["offer"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["offer"]
      sku       = var.custom_image != null ? var.custom_image["sku"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["sku"]
      version   = var.custom_image != null ? var.custom_image["version"] : var.linux_distribution_list[lower(var.linux_distribution_name)]["version"]
    }
  }

  os_disk {
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.os_disk_caching
    disk_encryption_set_id    = var.disk_encryption_set_id
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.enable_os_disk_write_accelerator
    name                      = var.os_disk_name
  }

  additional_capabilities {
    ultra_ssd_enabled = var.enable_ultra_ssd_data_disk_storage_support
  }

  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.storage_account_name != null ? data.azurerm_storage_account.storeacc.0.primary_blob_endpoint : var.storage_account_uri
    }
  }

  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }
}

# Alerts Module

module "alerts_vm" {
  source = "../../alerts"

  depends_on = [
    azurerm_linux_virtual_machine.linux_vm,
    data.azurerm_monitor_action_group.ag_group
  ]

  for_each = try(var.vm_alerts, {})

  alert_name          = "${var.name}-${var.all_alerts[each.value[1]].alert_name}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_linux_virtual_machine.linux_vm.id]
  alert_criteria      = var.all_alerts[each.value[1]].criteria
  action_group_id     = data.azurerm_monitor_action_group.ag_group[each.value[0]].id
  tags                = merge(try(each.value.tags, null), var.tags)
}


# Network Interface Module

module "nic" {
  source                        = "../nic"
  name                          = var.nic_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tags                          = var.tags
  ip_config_name                = "ipconfig"
  primary                       = true
  subnet_id                     = var.subnet_id
  enable_accelerated_networking = length(regexall(".*dev.*", var.nic_name)) > 0 == true ? false : true
}

# Optional unit test for VM using test.sh script file to test connectivity to a primary storage account, ssh to vm and informatica agent software registration at MDM portal
module "vm_tests" {
  source = "../unit_tests"

  depends_on = [azurerm_linux_virtual_machine.linux_vm,
  module.nic, module.dynamic_secret]

  count = lookup(var.settings, "scripts", {}) == {} ? 0 : 1

  type                 = try(var.settings.connection_type, "ssh")
  host                 = azurerm_linux_virtual_machine.linux_vm.private_ip_address
  user                 = var.admin_username
  password             = module.dynamic_secret.result
  scripts              = var.settings.scripts
  container            = try(var.settings.container, null)
  storage_account_name = var.storage_account_name
}

module "dynamic_secret" {
  source = "../../keyvault/secrets/secret_dynamic"

  name        = var.admin_username
  keyvault_id = var.keyvault_id
  value       = null
}

module "rbac_assignments" {
  source = "../../rbacv2"

  depends_on = [
    azurerm_linux_virtual_machine.linux_vm
  ]
  scope = azurerm_linux_virtual_machine.linux_vm.id

  for_each = try(var.settings.rbacs, {})

  role      = toset(each.value.role)
  type      = each.value.type
  principal = each.value.principal
}

# Check if SystemAssigned identity is set and create Key Vault Secrets User role for it
resource "azurerm_role_assignment" "kv" {

  count = var.managed_identity_type == "SystemAssigned" ? 1 : 0

  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.linux_vm.identity[0].principal_id

  depends_on = [azurerm_linux_virtual_machine.linux_vm]
}

#************************************************************************************************
# EXTENSIONS
#************************************************************************************************
resource "azurerm_virtual_machine_extension" "aad_extension" {

  count                = try(var.settings.aadlogin_enabled, false) == true ? 1 : 0
  name                 = "AADExtension"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm.id
  publisher            = "Microsoft.Azure.ActiveDirectory"
  type                 = "AADSSHLoginForLinux"
  type_handler_version = "1.0"
  tags                 = var.tags

  depends_on = [azurerm_linux_virtual_machine.linux_vm]
}

resource "azurerm_virtual_machine_extension" "mountscript" {
  name                 = "customMountScript"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": ""
    }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "sudo yum update -y; sudo yum install -y cifs-utils keyutils jq; sudo mkdir -p /mnt/${var.storage_account_name}/${var.fileshare_name}; sudo mount -t cifs //${var.storage_account_name}.file.core.windows.net/${var.fileshare_name} /mnt/${var.storage_account_name}/${var.fileshare_name} -o vers=3.0,username=${var.storage_account_name},password=${var.storage_account_key},dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30,mfsymlinks"
    }
  PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

