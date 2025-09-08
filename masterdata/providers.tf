# Azure API provider used in SFTP service creation for storage account
provider "azapi" {
  # Configuration options
}
provider "azurerm" {
  storage_use_azuread = true
  features {

    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
    }
  }
}

provider "random" {
  # Configuration options
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "hubcc_subscription"
  subscription_id            = "3xx-xxxx-xxx3f"
  storage_use_azuread        = true
  use_oidc                   = true
}

#Providers are listed here
terraform {
  required_version = ">= 1.5.1"
  # Following block is required for the new pipeline supportability
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained provider plugins.
      # source is not required for the hashicorp/* namespace as a measure of backward compatibility for commonly-used providers, but recommended for explicitness.

      version = "~> 3.70.0"
    }

    random = {
      version = "~> 3.6.1"
    }

    #Configure the Microsoft Azure Active Directory Provider
    azuread = {
      version = "~> 2.48.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.7.0"
    }

  }
}