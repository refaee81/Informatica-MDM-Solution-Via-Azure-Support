data "template_file" "script" {
  template = file(abspath("../scripts/${var.name}"))
  vars = {
    storage_account_name = "${var.storage_account_name}"
    fileshare_name       = "${var.fileshare_name}"
  }
}

resource "azurerm_storage_blob" "blob_script" {

  depends_on = [data.template_file.script]

  name                   = var.name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
  type                   = "Block"
  source_content         = data.template_file.script.rendered
}

