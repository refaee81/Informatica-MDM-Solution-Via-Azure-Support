resource "azurerm_storage_blob" "blob" {

  for_each = fileset("../environments/${var.environment}/upload_files", "${var.folder}/*")
  # files only dropped into selected container
  #name                   = split("/", each.key)[1]
  # Folder and files combo is dropped into selected container
  name                   = each.key
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  type                   = "Block"
  source                 = "../environments/${var.environment}/upload_files/${each.key}"
}
