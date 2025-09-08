variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}
variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}
variable "virtual_machine_size" {
  description = "The Virtual Machine SKU for the Virtual Machine, Default is Standard_A2_V2"
  default     = "Standard_A2_v2"
}
variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}

variable "computer_name" {
  description = "The username of the local administrator used for the Virtual Machine."
  default     = "azureadmin"
}

# variable "admin_password" {
#   description = "The Password which should be used for the local-administrator on this Virtual Machine"
#   default     = null
# }

variable "keyvault_id" {
  description = "Keyvault Id used for storing secrets"
  default     = null
}

variable "enable_encryption_at_host" {
  description = " Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
  default     = false
}
variable "name" {
  description = "The name of the virtual machine."
  default     = ""
}
variable "instances_count" {
  description = "The number of Virtual Machines required."
  default     = 1
}
variable "network_interface_ids" {
  description = "The network interface Ids used for Virtual Machine."
  type        = list(string)
}

variable "winrm_protocol" {
  description = "Specifies the protocol of winrm listener. Possible values are `Http` or `Https`"
  default     = null
}

variable "additional_unattend_content" {
  description = "The XML formatted content that is added to the unattend.xml file for the specified path and component."
  default     = null
}

variable "additional_unattend_content_setting" {
  description = "The name of the setting to which the content applies. Possible values are `AutoLogon` and `FirstLogonCommands`"
  default     = null
}

variable "source_image_id" {
  description = "The ID of an Image which each Virtual Machine should be based on"
  default     = null
}

variable "provision_vm_agent" {
  description = "provision_vm_agent"
  default     = true
}

variable "allow_extension_operations" {
  description = "allow_extension_operations"
  default     = true
}

variable "dedicated_host_id" {
  description = "The ID of a Dedicated Host where this machine should be run on."
  default     = null
}
variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine? Defaults to true."
  default     = true
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "StandardSSD_LRS"
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`"
  default     = "ReadWrite"
}

variable "disk_encryption_set_id" {
  description = "The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the `Reader` Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault"
  default     = null
}

variable "disk_size_gb" {
  description = "The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from."
  default     = null
}

variable "enable_os_disk_write_accelerator" {
  description = "Should Write Accelerator be Enabled for this OS Disk? This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`."
  default     = false
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk"
  default     = null
}

variable "enable_ultra_ssd_data_disk_storage_support" {
  description = "Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine"
  default     = false
}

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = any
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine."
  default     = null
  type        = any
}

variable "enable_boot_diagnostics" {
  description = "Should the boot diagnostics enabled?"
  default     = false
}

variable "storage_account_uri" {
  description = "The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics."
  default     = null
}


variable "availability_set_id" {
  description = "availability_set_id"
  default     = null
}


variable "encryption_at_host_enabled" {
  description = "encryption_at_host_enabled"
  default     = false
}


variable "proximity_placement_group_id" {
  description = "proximity_placement_group_id"
  default     = null
}
variable "admin_ssh_key_data" {
  description = "specify the path to the existing SSH key to authenticate Linux virtual machine"
  default     = null
}
variable "tags" {
  description = "(Required) Map of tags to be applied to the resource"
  type        = map(any)
}

variable "custom_image" {
  description = "Provide the custom image to this module if the default variants are not sufficient"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  default = null
}

variable "linux_distribution_list" {
  description = "Pre-defined Azure Linux VM images list"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
  default = {
    redhat82gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "82gen2"
      version   = "latest"
    },
    redhat85gen2 = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "85-gen2"
      version   = "latest"
    }
  }
}

variable "linux_distribution_name" {
  default     = "redhat85gen2"
  description = "Variable to pick an OS flavour for Linux based VM. Possible values include: centos8, ubuntu1804"
}

variable "windows_distribution_list" {
  description = "Pre-defined Azure Windows VM images list"
  type = map(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))

  default = {
    windows2012r2dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2012-R2-Datacenter"
      version   = "latest"
    },

    windows2016dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    },

    windows2019dc = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    },


    windows2010 = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "Windows-10"
      sku       = "rs5-enterprise"
      version   = "latest"
    },


    windows2019dc-gensecond = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter-gensecond"
      version   = "latest"
    },

    windows2019dc-gs = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter-gs"
      version   = "latest"
    },

    windows2019dc-containers = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter-with-Containers"
      version   = "latest"
    },

    windows2019dc-containers-g2 = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter-with-containers-g2"
      version   = "latest"
    },

    windows2019dccore = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter-Core"
      version   = "latest"
    },

    windows2019dccore-g2 = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-datacenter-core-g2"
      version   = "latest"
    },

    windowsdesktop = {
      publisher = "MicrosoftWindowsDesktop"
      offer     = "Windows-10"
      sku       = "20h2-evd"
      version   = "latest"
    },

    windows2016dccore = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter-Server-Core"
      version   = "latest"
    },

    mssql2017exp = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2019"
      sku       = "express"
      version   = "latest"
    },

    mssql2017dev = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2019"
      sku       = "sqldev"
      version   = "latest"
    },

    mssql2017std = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2019"
      sku       = "standard"
      version   = "latest"
    },

    mssql2017ent = {
      publisher = "MicrosoftSQLServer"
      offer     = "SQL2017-WS2019"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019std = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ws2019"
      sku       = "standard"
      version   = "latest"
    },

    mssql2019dev = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ws2019"
      sku       = "sqldev"
      version   = "latest"
    },

    mssql2019ent = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ws2019"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019ent-byol = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ws2019-byol"
      sku       = "enterprise"
      version   = "latest"
    },

    mssql2019std-byol = {
      publisher = "MicrosoftSQLServer"
      offer     = "sql2019-ws2019-byol"
      sku       = "standard"
      version   = "latest"
    }
  }
}


variable "windows_distribution_name" {
  default     = "windows2019dc"
  description = "Variable to pick an OS flavour for Windows based VM. Possible values include: winserver, wincore, winsql"
}

variable "vm_time_zone" {
  description = "Specifies the Time Zone which should be used by the Virtual Machine"
  default     = null
}
variable "enable_automatic_updates" {
  description = "Specifies if Automatic Updates are Enabled for the Windows Virtual Machine."
  default     = false
}

variable "license_type" {
  description = "Specifies the type of on-premise license which should be used for this Virtual Machine. Possible values are None, Windows_Client and Windows_Server."
  default     = "None"
}


variable "nic_name" {
  description = "Specifies the name of the NIC."
  default     = "None"
}

variable "subnet_id" {
  description = "Specifies the subnet to associate the NIC created for the virtual machine."
  default     = "None"
}

variable "loganalytics_workspace_id" {
  description = "Used for sending logs to LogAnalytics Workspace."
}

variable "loganalytics_workspace_key" {
  description = "Key for LogAnalytics Workspace."
}

variable "settings" {
  type = any
}

variable "availability_zone" {
  type    = any
  default = "1"

  validation {
    condition     = can(regex("^1$|^2$|^3$", var.availability_zone))
    error_message = "Err: Availability Zone is incorrect (1, 2 or 3)."
  }
}

variable "AGENT_NAME" {
  type = string
}

variable "AGENT_PASSWORD" {
  type = string

  sensitive = true
}

variable "RUNTIME_GROUP" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_account_key" {
  type = string
}

variable "vm_alerts" {
  type = map(any)
}

variable "all_alerts" {
  type = any
}

variable "action_groups" {
  type = any
}

variable "ag_rg" {
  description = "Resource Group name for Action Groups"
  type        = string
}

variable "environment" {
  description = "environment name"
  type        = string
}

variable "fileshare_name" {
  type = string
}

# new variable for virtual machine new updates Story#653281 
variable "patch_assessment_mode" {
  description = "The patch_assessment_mode for jump VM"
  type        = string
}
 
variable "patch_mode" {
  description = "The patch_mode for jump VM"
  type        = string
}

variable "vm_tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
  default     = {}
}

variable "bypass_platform_safety_checks" {
  description = "bypass_platform_safety_checks_on_user_schedule_enabled"
  default        = false
}