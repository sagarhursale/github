resource "null_resource" "install_awx" {

  connection {
    type        = "ssh"
    host        = var.server_ip
    user        = var.username
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "scripts/install_awx.sh"
    destination = "/tmp/install_awx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_awx.sh",
      "sudo /tmp/install_awx.sh"
    ]
  }
}