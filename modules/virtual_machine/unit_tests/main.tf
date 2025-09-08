data "azurerm_storage_container" "url" {
  name                 = var.container
  storage_account_name = var.storage_account_name
}

data "template_file" "test" {
  template = file(abspath("../scripts/${var.scripts.source}"))
  vars = {
    storage_container_url = data.azurerm_storage_container.url.resource_manager_id
    mdmagentadmin         = var.user
    tmpdir                = "/home/${var.user}"
  }
}

resource "null_resource" "tests_run" {

  triggers = {
    test = "${data.template_file.test.rendered}"
  }

  provisioner "file" {
    source      = data.template_file.test.rendered
    destination = "/home/${var.user}/test.sh"

    connection {
      type     = "ssh"
      host     = var.host
      user     = var.user
      password = var.password
      timeout  = "30s"
    }
  }

  provisioner "remote-exec" {
    /* inline = [
      "chmod +x /home/${var.user}/test.sh",
      "/home/${var.user}/test.sh"
    ] */

    script = <<-EOF
      #!/bin/bash
      set -e
      chmod +x /home/${var.user}/test.sh
      /home/${var.user}/test.sh
      cat /home/${var.user}/test.log
    EOF

    connection {
      type     = "ssh"
      host     = var.host
      user     = var.user
      password = var.password
      timeout  = "30s"
    }
  }
}

output "test_output" {
  value = null_resource.tests_run.id
}
