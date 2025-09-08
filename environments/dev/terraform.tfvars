# Environment
environment = "dev"

# Subscription 
subscription    = "xx-xxxx-xxx-xxxx"
subscription_id = "xxx-xxx-xxx-xxx"
environment_sub = "test"

# Region
azure_region       = "canadacentral"
azure_region_short = "cc"

# Terraform Service Principal
service_principal_terraform_name = "sp-dxx-xxxx-xxx-01"

# AAD group
group_dp_platform_engineers = "dp-xx-xxxx-xxx-dmp"

# Managed Identities

managed_identities = {
  msi1 = {
    # Used by Secure Agent VMs to read secrets in Key Vault
    # Assign Key Vault Reader and Key Vault Secret User
    name = "msi-xx-xxxx-xxxvm-cc-01"
    tags = {
      resource = "virtual machine,storage_account"
    }
  }
}

# Resource group
# tf_resource_group = "rg-xx-xxxx-xxx-tf-01"

# TF State Storage account
tf_sa_name          = "sadevxx-xxxx-xxxc7f3"
sa_replication_type = "GRS"
sa_account_tier     = "Standard"
sa_min_tls_version  = "TLS1_2"
sa_identity_type    = "SystemAssigned"

# Storage account network rules
sa_network_rules_default_action = "Deny"

# Container name for Terraform state file
tf_container_name = "txx-xxxx-xxx-dpe"

# External VNet/Subnet
#vnet_snet_extnl_pipelines_vnet_containers_cloudx   = "/subscriptions/xx-xxxx-xxx"
vnet_snet_extnl_pipelines_vnet_containers_clouds2x = "/subscriptions/3xx-xxxx-xxx/xx-xxxx-xxx/providers/Microsoft.Network/virtualNetworks/vnet-core-hub-cc-01/subnets/snet-coxx-xxxx-xxxc-01"
#vnet_snet_core_hub = "/subscriptions/3xx-xxxx-xxxcc-01/subnets/[*]"

# Tags
dpe_tags = {
  "application"     = "Masterdata"
  "environment"     = "DEV"
  "technicalLead"   = "xx-xxxx-xxx"
  "budgetAuthority" = "xx-xxxx-xxx"
}

# Application
appl = "masterdata"


# Networking


# VNet and Subnet Variables
dns_servers        = ["xx-xxxx-xxx", "xx-xxxx-xxx"]
vnet_address_space = "xx-xxxx-xxx.0/25"
vnet_name          = "vnet-xx-xxxx-xxx-cc-01"
vnet_rg_name       = "rg-xx-xxxx-xxx-cc-01"
subnets = {
  agents = {
    "prefixes" : ["xx-xxxx-xxx/28"],
    "service_endpoints" : ["Microsoft.Storage", "Microsoft.KeyVault"],
    "private_endpoint_network_policies_enabled" : true,
    "private_link_service_network_policies_enabled" : false,
    "service_delegations" : {},
    route_table = "rt_main",
    "nsg" : {
      "rules" : [
        {
          name                       = "AllowAzureBastionSshInbound"
          priority                   = 161
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = 22
          source_address_prefix      = "1xx-xxxx-xxx2/26"
          destination_address_prefix = "*"
          description                = "Allow Azure Bastion inbound traffic"
        },
        {
          name                       = "AllowAzureLoadBalancerInbound"
          priority                   = 4095
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
          description                = "Allow loadbalancer inbound from the virtual network"
        },
        #{
        #  name                       = "AllowCloudXAgentsSubnetInbound"
        #  priority                   = 4093
        #  direction                  = "Inbound"
        #  access                     = "Allow"
        #  protocol                   = "Tcp"
        #  source_port_range          = "*"
        #  destination_port_range     = "443,22"
        #  source_address_prefix      = "1xx-xxxx-xxx0/27"
        #  destination_address_prefix = "*"
        #  description                = "Allow inbound traffic from DevOps Agents of CloudX pool"
        #},
        {
          name                       = "AllowClouds2XAgentsSubnetInbound"
          priority                   = 4090
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443,22"
          source_address_prefix      = "1xx-xxxx-xxx2/27"
          destination_address_prefix = "*"
          description                = "Allow inbound traffic from DevOps Agents of Clouds2X pool"
        }
        # {
        #   name                       = "DenyVNetAddressSpaceInbound"
        #   priority                   = 4096
        #   direction                  = "Inbound"
        #   access                     = "Deny"
        #   protocol                   = "*"
        #   source_port_range          = "*"
        #   destination_port_range     = "*"
        #   source_address_prefix      = "1xx-xxxx-xxx.0/24"
        #   destination_address_prefix = "1xx-xxxx-xxx0/24"
        #   description                = "Deny inbound vnet traffic particular to this address space"
        # }
        # Default NSG inbound and outbound rules are deployed in addition to the custom security rules when NSG is created 
      ]
    },
  }
  elastic = {
    "prefixes" : ["1xx-xxxx-xxx.16/28"],
    "service_endpoints" : ["Microsoft.Storage", "Microsoft.KeyVault"],
    "private_endpoint_network_policies_enabled" : true,
    "private_link_service_network_policies_enabled" : false,
    "service_delegations" : {},
    route_table = "rt_main",
    "nsg" : {
      "rules" : [
        {
          name                       = "AllowAzureLoadBalancerInbound"
          priority                   = 4095
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
          description                = "Allow loadbalancer inbound from the virtual network"
        }
      ]
    },
  }
  pep = {
    "prefixes" : ["1xx-xxxx-xxx6/28"],
    "service_endpoints" : ["Microsoft.Storage", "Microsoft.KeyVault"],
    "private_endpoint_network_policies_enabled" : false,
    "private_link_service_network_policies_enabled" : false,
    "service_delegations" : {},
    route_table = "rt_main",
    "nsg" : {
      "rules" : [
        {
          name                       = "AllowAgentsSubnetInbound"
          priority                   = 4095
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "2xx-xxxx-xxx445"
          source_address_prefix      = "1xx-xxxx-xxx.0/28"
          destination_address_prefix = "*"
          description                = "Allow inbound traffic from Agents Subnet"
        },
        #{
        #  name                       = "AllowCloudXAgentsSubnetInbound"
        #  priority                   = 4093
        #  direction                  = "Inbound"
        #  access                     = "Allow"
        #  protocol                   = "Tcp"
        #  source_port_range          = "*"
        #  destination_port_range     = "443"
        #  source_address_prefix      = "1xx-xxxx-xxx/27"
        #  destination_address_prefix = "*"
        #  description                = "Allow inbound traffic from DevOps Agents of CloudX pool"
        #},
        {
          name                       = "AllowClouds2XAgentsSubnetInbound"
          priority                   = 4091
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "1xx-xxxx-xxx/27"
          destination_address_prefix = "*"
          description                = "Allow inbound traffic from DevOps Agents of Clouds2X pool"
        }
      ]
    },
  }
}


## Routes


route_tables = {
  rt_main = {
    re1 = {
      name                   = "to_internet"
      prefix                 = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.84"
    },
    re2 = {
      name                   = "to_on_prem1"
      prefix                 = "1xx-xxxx-xxx8"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.132"
    },
    re3 = {
      name                   = "to_on_prem2"
      prefix                 = "1xx-xxxx-xxx0/16"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re4 = {
      name                   = "to_on_prem3"
      prefix                 = "1xx-xxxx-xxx0/12"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx"
    },
    re5 = {
      name                   = "canada_central"
      prefix                 = "10xx-xxxx-xxx0.0/16"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re6 = {
      name          = "to_avd_control_plane"
      prefix        = "WindowsVirtualDesktop"
      next_hop_type = "Internet"
    },
    re7 = {
      name                   = "to_AzureFirewallSubnet"
      prefix                 = "1xx-xxxx-xxx28/26"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re8 = {
      name                   = "to_GatewaySubnet"
      prefix                 = "1xx-xxxx-xxx.0/26"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re9 = {
      name          = "to_microsoft_cdn"
      prefix        = "AzureFrontDoor.Backend"
      next_hop_type = "Internet"
    },
    re10 = {
      name                   = "to_snet-core-appgw-cc-01"
      prefix                 = "1xx-xxxx-xxx0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx32"
    },
    re11 = {
      name                   = "to_snet-core-c8000vazinternal-cc-01"
      prefix                 = "1xx-xxxx-xxx28"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.132"
    },
    re12 = {
      name                   = "to_snet-core-c8000ver-cc-01"
      prefix                 = "1xx-xxxx-xxx/28"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx2"
    },
    re13 = {
      name                   = "to_snet-core-c8000vinternet-cc-01"
      prefix                 = "1xx-xxxx-xxx64/28"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx32"
    },
    re14 = {
      name                   = "to_snet-core-c8000vvpn-cc-01"
      prefix                 = "10.101.3.16/28"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10xx-xxxx-xxx2"
    },
    re15 = {
      name                   = "to_snet-core-dns-cc-01"
      prefix                 = "1xx-xxxx-xxx96/27"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re16 = {
      name                   = "to_snet-core-iam-cc-01"
      prefix                 = "1xx-xxxx-xxx/26"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.132"
    },
    re17 = {
      name                   = "to_snet-core-pe-cc-01"
      prefix                 = "1xx-xxxx-xxx0/23"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.132"
    },
    re18 = {
      name                   = "to_snet-core-ss-cc-01"
      prefix                 = "10xx-xxxx-xxx4/26"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx132"
    },
    re19 = {
      name                   = "to_snet-core-vmtest-cc-01"
      prefix                 = "1xx-xxxx-xxx0/24"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx32"
    },
    re20 = {
      name                   = "azdosha" #702867_RITM0059962
      prefix                 = "1xx-xxxx-xxx2/27"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "1xx-xxxx-xxx.132"
    },
    re21 = {
      name          = "RHUI1"
      prefix        = "4xx-xxxx-xxxxx91/32"
      next_hop_type = "Internet"
    },
    re22 = {
      name          = "RHUI2"
      prefix        = "1xx-xxxx-xxx32"
      next_hop_type = "Internet"
    },
    re23 = {
      name          = "RHUI3"
      prefix        = "5xx-xxxx-xxx18/32"
      next_hop_type = "Internet"
    },
    re24 = {
      name          = "RHUI4"
      prefix        = "52xx-xxxx-xxx3/32"
      next_hop_type = "Internet"
    },
    re25 = {
      name          = "RHUI5"
      prefix        = "5xx-xxxx-xxx8/32"
      next_hop_type = "Internet"
    }
  }
}


# General Resources


# KeyVaults

keyvaults = {
  kv1 = {
    enabled_for_disk_encryption = true
    enabled_for_deployment      = true
    soft_delete_retention_days  = 90
    purge_protection_enabled    = true
    sku_name                    = "standard"
    enable_rbac_authorization   = true
    private_endpoint_enabled    = true
    private_endpoint_subnet     = "pep"

    # access_policy is automatically disabled when rbac_authorization is true. Commenting policy is not mandatory in that case.
    access_policy = [
      # {
      #   object_id = "74axx-xxxx-xxx683"
      #   key_permissions = [
      #     "Get",
      #   ]

      #   secret_permissions = [
      #     "Get",
      #   ]

      #   storage_permissions = [
      #     "Get",
      #   ]
      # }
    ]

    network_acl = {
      virtual_network_subnets = ["agents"]
      bypass                  = "AzureServices"
      ip_rules                = []
      default_action          = "Deny"
    }

    rbacs = {
      #This is required to allow Data Platfrom Engineers to key vault administrator role
      kv-dpengineers-dmp-rbac = {
        role      = ["Key Vault Administrator"]
        type      = "group"
        principal = "dp-xx-xxxx-xxxrs-dmp"
      },
      #These are the required roles to allow terraform service principal to Key Vault operations
      kv-devopsagent-rbac = {
        role      = ["Key Vault Crypto Officer", "Key Vault Secrets Officer", "Key Vault Secrets User"]
        type      = "service_principal"
        principal = "sp-xx-xxxx-xxxent-01"
      },
      kv-msi-rbac = {
        role      = ["Key Vault Secrets User"]
        type      = "service_principal"
        principal = "msi-xx-xxxx-xxx-vm-cc-01"
      },
      # temporary admin for roman for keyvault
      kv-romantemporary-rbac = {
        role      = ["Key Vault Administrator", "Key Vault Secrets Officer", "Key Vault Secrets User", "Contributor"]
        type      = "user"
        principal = "RAxx-xxxx-xxx.ca"
      },
      #These are the required roles to allow kyndryl to access the key vault secret for a virtual machine 
      /* kyndryl is no more with EDC as of August 2023
      kv-kyndryl-rbac-01 = {
        role      = ["Key Vault Reader", "Key Vault Secrets User"]
        type      = "group"
        principal = "EDC-ISM-AzureLinux"
      }
      kv-kyndryl-rbac-02 = {
        role      = ["Key Vault Reader", "Key Vault Secrets User"]
        type      = "group"
        principal = "Exx-xxxx-xxxxxPIM"
      }*/
    }

    # To set known secrets
    # secrets = {
    #   agentName = "masterdata_agent"
    #   agentPassword = "placeholder"
    #   runtimeGroup = "DExx-xxxx-xxxA-01"      
    # }

    diagnostics_settings = {
      # default = {
      #   name                           = "Sentinel_audit_logs"
      #   destination_type               = "log_analytics"
      #   log_analytics_workspace_id     = "a69xx-xxxx-xxx82"
      #   log_analytics_resource_id      = "/subscriptions/xx-xxxx-xxx32"
      #   log_analytics_destination_type = "Dedicated"
      #   storage_account_id             = ""
      #   categories = {
      #     log = [
      #       # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AuditEvent", true, true, 0],
      #       ["AzurePolicyEvaluationDetails", true, false, 0],
      #     ]
      #     metric = [
      #       #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AllMetrics", false, false, 0],
      #     ]
      #   }
      # }
    }
  }
}

# Storage Accounts

storage_accounts = {
  primary_storage = {
    account_kind                    = "StorageV2" #Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2
    account_tier                    = "Standard"  #Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid
    account_replication_type        = "LRS"       # https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
    min_tls_version                 = "TLS1_2"    # Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts.
    allow_nested_items_to_be_public = false
    #public_network_access_enabled   = false
    is_hns_enabled            = true
    enable_https_traffic_only = true
    shared_access_key_enabled = true # Terraform uses Shared Key Authorisation to provision Storage Containers, Blobs and other items - when Shared Key Access is disabled, 
    # you will need to enable the storage_use_azuread flag in the Provider block to use Azure AD for authentication, however not all Azure 
    # Storage services support Active Directory authentication.
    identity_type                     = "SystemAssigned"
    managed_identity_id               = "msi1"
    infrastructure_encryption_enabled = true # This can only be true when account_kind is StorageV2 or when account_tier is Premium and account_kind is BlockBlobStorage
    default_to_oauth_authentication   = true #Default to Azure Active Directory authorization in the Azure portal
    # publish_microsoft_endpoints       = true
    sa_sas_policy = "true" 

    sftp = {
      enabled        = false
      hasSshPassword = true
      username       = "mdmsftpuser"
      container      = "raw"
      permissions    = "cwld"
    }

    private_endpoint_enabled      = true
    private_endpoint_subnet       = "pep"
    private_endpoint_subresources = ["blob", "dfs"]
    blob = {
      delete_retention_days = 90
      versioning_enabled    = false # not supported for hns-enabled account yet
    }

    container_delete_retention_days = 90
    containers = {
      ct1 = {
        name                = "general"
        access_type         = "Private"
        upload_files_folder = []
        rbacs = {

          # Enables the Secure Agents' User Assigned Managed Identity to read, write, and delete Azure Storage containers and blobs
          sa-container-msi = {
            role      = ["Storage Blob Data Contributor"]
            type      = "service_principal"
            principal = "msi-xx-xxxx-xxxcc-01"
          }
        }
      }
    }
    network_rules = {
      bypass                  = ["Logging", "Metrics", "AzureServices"]
      default_action          = "Deny"
      ip_rules                = []
      virtual_network_subnets = ["agents"]
    }
    rbacs = {

      # Enables the Azure Devops Pipeline Agent Identity to Create, Modify or Delete the Storage Account, Blob Containers, etc.
      sa-devopsagent-rbac = {
        role      = ["Contributor"]
        type      = "service_principal"
        principal = "sp-dxx-xxxx-xxxment-01"
      }

      # Enables the Secure Agents' User Assigned Managed Identity to view the Storage Account and its contents
      sa-msi-rbac = {
        role      = ["Reader"]
        type      = "service_principal"
        principal = "msi-xx-xxxx-xxx-cc-01"
      }

      # system assigned managed identity is required for tests completion (REST API calls to storage account)
      /* sa-msi-agent2 = {
        role      = ["Reader", "Storage Blob Data Contributor"]
        type      = "service_principal"
        principal = "vm-dxx-xxxx-xxxc-02"
      }

      # system assigned managed identity is required for tests completion (REST API calls to storage account)
      /* sa-msi-agent1 = {
        role      = ["Reader", "Storage Blob Data Contributor"]
        type      = "service_principal"
        principal = "vm-dxx-xxxx-xxxa-cc-01"
      } */

    }

    management_policies = {
      # rules = {
      #   rule_1 = {
      #     name    = "rule1"
      #     enabled = true
      #     filters = {
      #       filter_specs = {
      #         prefix_match = ["container1/prefix1"]
      #         blob_types   = ["blockBlob"]
      #         # This code can only be used if enable `BlobIndex`
      #         #match_blob_index_tag = {
      #         #match_blob_index_tag_specs = {
      #         #  name      = "tag1"
      #         #  operation = "=="
      #         #  value     = "val1"
      #         #}
      #         #}
      #       }
      #     }
      #     actions = {
      #       base_blob = {
      #         blob_specs = {
      #           tier_to_cool_after_days_since_modification_greater_than    = 11
      #           tier_to_archive_after_days_since_modification_greater_than = 51
      #           delete_after_days_since_modification_greater_than          = 101
      #         }
      #       }
      #       snapshot = {
      #         snapshot_specs = {
      #           change_tier_to_archive_after_days_since_creation = 90
      #           change_tier_to_cool_after_days_since_creation    = 23
      #           delete_after_days_since_creation_greater_than    = 31
      #         }
      #       }
      #       version = {
      #         version_specs = {
      #           change_tier_to_archive_after_days_since_creation = 9
      #           change_tier_to_cool_after_days_since_creation    = 90
      #           delete_after_days_since_creation                 = 3
      #         }
      #       }
      #     }
      #   }
      # }
    }

    # custom_domain = {
    #   name          = ""
    #   use_subdomain = false
    # }

    diagnostics_settings = {
      # default = {
      #   name                           = "Sentinel_audit_logs"
      #   destination_type               = "log_analytics" # or storage
      #   log_analytics_workspace_id     = "xx-xxxx-xxx82"
      #   log_analytics_resource_id      = "/subscriptions/fxx-xxxx-xxxace946532"
      #   log_analytics_destination_type = "Dedicated"
      #   storage_account_id             = ""
      #   categories = {
      #     log = [
      #       # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AuditEvent", true, true, 0],
      #       ["AzurePolicyEvaluationDetails", true, false, 0],
      #     ]
      #     metric = [
      #       #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AllMetrics", false, false, 0],
      #     ]
      #   }
      # }
    }
  },
  utility_storage = {

    name                            = "sadevmasterdatalogscc01"
    account_kind                    = "StorageV2" #Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2
    account_tier                    = "Standard"  #Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid
    account_replication_type        = "LRS"       # https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
    min_tls_version                 = "TLS1_2"    # Possible values are TLS1_0, TLS1_1, and TLS1_2. Defaults to TLS1_0 for new storage accounts.
    allow_nested_items_to_be_public = false
    #public_network_access_enabled   = false
    is_hns_enabled            = false
    enable_https_traffic_only = false
    shared_access_key_enabled = true # Terraform uses Shared Key Authorisation to provision Storage Containers, Blobs and other items - when Shared Key Access is disabled, 
    # you will need to enable the storage_use_azuread flag in the Provider block to use Azure AD for authentication, however not all Azure 
    # Storage services support Active Directory authentication.
    identity                          = "SystemAssigned"
    infrastructure_encryption_enabled = false # This can only be true when account_kind is StorageV2 or when account_tier is Premium and account_kind is BlockBlobStorage

    private_endpoint_enabled      = true
    private_endpoint_subnet       = "pep"
    private_endpoint_subresources = ["blob", "file"]
    blob = {
      delete_retention_days = 30
      versioning_enabled    = false # not supported for hns-enabled account yet
    }

    container_delete_retention_days = 30
    containers = {
      swagger = {
        name        = "swagger"
        access_type = "Private"
      }
      scripts = {
        name                = "scripts"
        access_type         = "Private"
        upload_files_folder = []
        upload_scripts      = []
        fileshare           = "fs1"
        rbacs = {

          # Enables the Secure Agents' User Assigned Managed Identity to read, write, and delete Azure Storage containers and blobs
          sa-container-msi = {
            role      = ["Storage Blob Data Contributor"]
            type      = "service_principal"
            principal = "msi-xx-xxxx-xxx-cc-01"
          }
          roman_temporary = {
            role      = ["Storage Blob Data Contributor"]
            type      = "user"
            principal = "RAxx-xxxx-xxxca"
          }
        }
      }
    }
    network_rules = {
      bypass                  = ["Logging", "Metrics", "AzureServices"]
      default_action          = "Deny"
      ip_rules                = []
      virtual_network_subnets = ["agents"]
    }
    rbacs = {
      sa-devopsagent-rbac = {
        role      = ["Storage Blob Data Owner", "Reader"]
        type      = "service_principal"
        principal = "spxx-xxxx-xxx-01"
      }

      sa-msi-rbac = {
        role      = ["Storage Blob Data Contributor", "Contributor"]
        type      = "service_principal"
        principal = "msi-xx-xxxx-xxxcc-01"
      }

      roman_temporary = {
        role      = ["Contributor"]
        type      = "user"
        principal = "Rxx-xxxx-xxxca"
      }
    }

    fileshares = {
      fs1 = {
        name     = "agentshare"
        protocol = "SMB" // or SMB
        quota    = 5120

        rbacs = {
          msi_dev = {
            role      = ["Storage File Data SMB Share Contributor"]
            type      = "service_principal"
            principal = "msi-xx-xxxx-xxx-cc-01"
          }
        }
      }
    }

    management_policies = {
      # rules = {
      #   rule_1 = {
      #     name    = "rule1"
      #     enabled = true
      #     filters = {
      #       filter_specs = {
      #         prefix_match = ["container1/prefix1"]
      #         blob_types   = ["blockBlob"]
      #         # This code can only be used if enable `BlobIndex`
      #         #match_blob_index_tag = {
      #         #match_blob_index_tag_specs = {
      #         #  name      = "tag1"
      #         #  operation = "=="
      #         #  value     = "val1"
      #         #}
      #         #}
      #       }
      #     }
      #     actions = {
      #       base_blob = {
      #         blob_specs = {
      #           tier_to_cool_after_days_since_modification_greater_than    = 11
      #           tier_to_archive_after_days_since_modification_greater_than = 51
      #           delete_after_days_since_modification_greater_than          = 101
      #         }
      #       }
      #       snapshot = {
      #         snapshot_specs = {
      #           change_tier_to_archive_after_days_since_creation = 90
      #           change_tier_to_cool_after_days_since_creation    = 23
      #           delete_after_days_since_creation_greater_than    = 31
      #         }
      #       }
      #       version = {
      #         version_specs = {
      #           change_tier_to_archive_after_days_since_creation = 9
      #           change_tier_to_cool_after_days_since_creation    = 90
      #           delete_after_days_since_creation                 = 3
      #         }
      #       }
      #     }
      #   }
      # }
    }

    # custom_domain = {
    #  name          = ""
    #  use_subdomain = false
    # } 

    diagnostics_settings = {
      # default = {
      #   name                           = "Sentinel_audit_logs"
      #   destination_type               = "log_analytics" # or storage
      #   log_analytics_workspace_id     = "a6xx-xxxx-xxxecxx-xxxx-xxx82"
      #   log_analytics_resource_id      = "/subscriptions/xx-xxxx-xxx/workspaces/loganalyticsworkspace946532"
      #   log_analytics_destination_type = "Dedicated"
      #   storage_account_id             = ""
      #   categories = {
      #     log = [
      #       # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AuditEvent", true, true, 0],
      #       ["AzurePolicyEvaluationDetails", true, false, 0],
      #     ]
      #     metric = [
      #       #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]
      #       ["AllMetrics", false, false, 0],
      #     ]
      #   }
      # }
    }

    tags = {
      "resourceBypass" = "true"
    }
  }
}

# Virtual Machines

compute = {
  secure_agent1 = {
    name_suffix                     = "01"
    admin_username                  = "mdmagentadmin"
    linux_distribution_name         = "redhat85gen2"
    disable_password_authentication = false
    virtual_machine_size            = "Standard_B4ms"
    ip_config_name                  = "ipcfg-edcmdm"
    disk_size                       = 512
    use_disk_encryption_set         = [true, "des1"]
    availability_zone               = 1
    kv_instance                     = "kv1"
    kv_password_secret_expiration   = "2026-01-25T15:13:08Z"
    auto_key_rotation_enabled       = true
    subnet                          = "agents"
    managed_identity_type           = "SystemAssigned, UserAssigned"
    managed_identity_id             = "msi1"
    log_analytics_workspace         = "" 
    aadlogin_enabled                = false
    runtime_group                   = "DEV-MASTERDATA-01"
    container                       = ""
    storage_account                 = "utility_storage"
    fileshare_name                  = "agentshare"
    alerts = {
      # ["action group key","alert key"]
      #default = ["ag1", "a1"]
    }

    scripts = {
      /* source      = "test.sh"
      destination = "/tmp/test.sh"
      inlinecommand = [
        "chmod +x /tmp/test.sh",
        "bash /tmp/test.sh",
        "cat /tmp/test.log"
      ] */
    }
    # this script was for the purpose of creating a backup resource group .. story#626392 ... Accenture will take care of this now
    #backup_enabled_vms = ["vm-xx-xxxx-xxx-cc-01"] 
    rbacs = {
      temporary_roman_vm_contributor = {
        role      = ["Contributor"]
        type      = "user"
        principal = "RAbxx-xxxx-xxxa"
      }
      temporary_scott_vm_contributor = {
        role      = ["Contributor"]
        type      = "user"
        principal = "sbxx-xxxx-xxxxx-xxx.ca"
      }
      temporary_lucius_vm_contributor = {
        role      = ["Contributor"]
        type      = "user"
        principal = "haxx-xxxx-xxxca"
      }
    }
  }

  secure_agent2 = {
    name_suffix                     = "02"
    admin_username                  = "mdmagentadmin2"
    linux_distribution_name         = "redhat85gen2"
    disable_password_authentication = false
    virtual_machine_size            = "Standard_B4ms"
    ip_config_name                  = "ipcfg-edcmdm"
    disk_size                       = 512
    use_disk_encryption_set         = [true, "des1"]
    availability_zone               = 1
    kv_instance                     = "kv1"
    kv_password_secret_expiration   = "2026-01-25T15:13:08Z"
    auto_key_rotation_enabled       = true
    subnet                          = "agents"
    managed_identity_type           = "SystemAssigned, UserAssigned"
    managed_identity_id             = "msi1"
    log_analytics_workspace         = "" #story 699719 # decommission law1
    aadlogin_enabled                = false
    runtime_group                   = "DEV-MASTERDATA-01"
    alerts = {
      # ["action group key","alert key"]
      #default = ["ag1", "a1"]
    }
    # VM test-related variables
    container       = ""
    storage_account = "utility_storage"
    fileshare_name  = "agentshare"
    scripts = {
      /* source = "test.sh" */
    }

    # this script was for the purpose of creating a backup resource group .. 
    #backup_enabled_vms = ["vm-xx-xxxx-xxxc-02"]


    rbacs = {
      temporary_roman_vm_contributor = {
        role      = ["Virtual Machine User Login", "Contributor"]
        type      = "user"
        principal = "RAxx-xxxx-xxxa"
      }
    }
  }
}

disk_encryption_sets = {
  des1 = {
    name_suffix               = "01"
    kv_instance               = "kv1"
    auto_key_rotation_enabled = true
  }
}

# Log Analytics #story 699719 Decommission of DEV LAW

log_analytics = {
  #law1 = {
  #  name                       = "law-xx-xxxx-xxxc-01"
  #  daily_quota_gb             = 5
  #  internet_ingestion_enabled = false
  #  internet_query_enabled     = true
    # reservation_capacity_in_gb_per_day = 100
    #sku               = "PerGB2018"
    #retention_in_days = 31
    #tags              = {}

    #rbacs = {

      #law-devopsagent-temporary = {
        #role      = ["Log Analytics Contributor"]
        #type      = "service_principal"
        #principal = "sp-xx-xxxx-xxx01"
      #}

      #law-romantemporary-rbac = {
        #role      = ["Log Analytics Contributor"]
        #type      = "user"
        #principal = "RAxx-xxxx-xxxa"
      #}
    #}
  #}
}

# Action group will be created using module

action_group = {
  ag1 = {
    ag_name    = "AzureOps"
    short_name = "take_action"
    emails = [
      {
        name          = "Ramsey"
        email_address = "RAxx-xxxx-xxxca"
      }
    ]
  }
}

# Alerts to be used with VMs

alerts = {
  a1 = {
    alert_name = "basemetrics"
    criteria = [
      {
        metric_namespace = "Azure.VM.Linux.GuestMetrics"
        metric_name      = "mem/used_percent"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 90
      },
      {
        metric_namespace = "Azure.VM.Linux.GuestMetrics"
        metric_name      = "disk/free_percent"
        aggregation      = "Total"
        operator         = "LessThan"
        threshold        = 95
      },
      {
        metric_namespace = "Azure.VM.Linux.GuestMetrics"
        metric_name      = "cpu/usage_active"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 92
      }
    ]
  }
}

# Resource Groups permissions and locks

resource_groups = {
  agents = {
    rbacs = {
      rg-masterdata-dpe-rbac = {
        role      = ["Reader", "Backup Operator"]
        type      = "group"
        principal = "dp-xx-xxxx-xxx-dev"
      }
    }
  },
  general = {
    rbacs = {
      rg-masterdata-dpe-rbac = {
        role      = ["Reader", "Backup Operator"]
        type      = "group"
        principal = "dp-xx-xxxx-xxxpe-dev"
      }
    }
  },
  network = {
    rbacs = {
      /* rg-masterdata-dpe-rbac = {
      /* rg-masterdata-dpe-rbac = {
        role      = ["Reader"]
        type      = "group"
        principal = "dp-xx-xxxx-xxx-dev"
      } */
    }
  }
}

#story# 653281
patch_assessment_mode = "AutomaticByPlatform"
patch_mode            = "AutomaticByPlatform"

vm_tags = {
  "ManagedBy" = "ISM"
}


bypass_platform_safety_checks = true

sa_private_link_access = true

