terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "1.7.0"
    }
  }
}

# Enable Sftp
resource "azapi_update_resource" "enable_sftp" {
  type        = "Microsoft.Storage/storageAccounts@2022-05-01"
  resource_id = var.resource_id

  body = jsonencode({
    properties = {
      isSftpEnabled = var.isSftpEnabled
    }
  })
}

# Create Local User
resource "azapi_resource" "sftp_user" {
  type      = "Microsoft.Storage/storageAccounts/localUsers@2022-05-01"
  parent_id = var.resource_id
  name      = var.username

  body = jsonencode({
    properties = {
      hasSshPassword = var.sshPassword,
      homeDirectory  = "${var.container}/"
      hasSharedKey   = true,
      hasSshKey      = false,
      permissionScopes = [{
        permissions  = "${var.permissions}",
        service      = "blob",
        resourceName = "${var.container}"
      }]
    }
  })
}

# Retrieve password by regenerating
resource "azapi_resource_action" "generate_sftp_user_password" {
  type        = "Microsoft.Storage/storageAccounts/localUsers@2022-05-01"
  resource_id = azapi_resource.sftp_user.id
  action      = "regeneratePassword"
  body = jsonencode({
    username = azapi_resource.sftp_user.name
  })

  response_export_values = ["sshPassword"]

}

output "sftp_password" {
  value = jsondecode(azapi_resource_action.generate_sftp_user_password.output).sshPassword
}
