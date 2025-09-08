output "id" {
  description = "The ID of the Storage Account"
  value       = try(azurerm_storage_account.stg_with_prevent_destroy[0].id, azurerm_storage_account.stg_without_prevent_destroy[0].id)
}

output "name" {
  description = "The name of the Storage Account"
  value       = try(azurerm_storage_account.stg_with_prevent_destroy[0].name, azurerm_storage_account.stg_without_prevent_destroy[0].name)
}

output "location" {
  description = "The location of the Storage Account"
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name of the Storage Account"
  value       = var.resource_group_name
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = try(azurerm_storage_account.stg_with_prevent_destroy[0].primary_blob_endpoint, azurerm_storage_account.stg_without_prevent_destroy[0].primary_blob_endpoint)
}

output "primary_access_key" {
  description = "The endpoint URL for blob storage in the primary location."
  value       = try(azurerm_storage_account.stg_with_prevent_destroy[0].primary_access_key, azurerm_storage_account.stg_without_prevent_destroy[0].primary_access_key)
  sensitive = true
}


output "identity" {
  description = " An identity block, which contains the Identity information for this Storage Account. Exports principal_id (The Principal ID for the Service Principal associated with the Identity of this Storage Account), tenand_id (The Tenant ID for the Service Principal associated with the Identity of this Storage Account)"
  value       = try(try(azurerm_storage_account.stg_with_prevent_destroy[0].identity, azurerm_storage_account.stg_without_prevent_destroy[0].identity), null)
}

output "rbac_id" {
  description = " The Principal ID for the Service Principal associated with the Identity of this Storage Account. (Extracted from the identity block)"
  value       = try(azurerm_storage_account.stg_with_prevent_destroy[0].identity.0.principal_id, azurerm_storage_account.stg_without_prevent_destroy[0].identity.0.principal_id)
}



output "primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = try(try(azurerm_storage_account.stg_with_prevent_destroy[0].primary_web_host, azurerm_storage_account.stg_without_prevent_destroy[0].primary_web_host), null)
}

output "primary_connection_string" {
  value = try(try(azurerm_storage_account.stg_with_prevent_destroy[0].primary_connection_string, azurerm_storage_account.stg_without_prevent_destroy[0].primary_connection_string), null)
}


output "primary_blob_connection_string" {
  value = try(try(azurerm_storage_account.stg_with_prevent_destroy[0].primary_blob_connection_string, azurerm_storage_account.stg_without_prevent_destroy[0].primary_blob_connection_string), null)
}

output "sftp_password" {
  value = module.sftp[*].sftp_password
}
