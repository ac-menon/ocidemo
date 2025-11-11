resource "oci_core_instance" "web-01" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-01"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet.id
  fault_domain = "FAULT-DOMAIN-1"

  source_details {
    source_type             = "image"
    source_id               = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo setsebool -P httpd_can_network_connect 1",
      "sudo setsebool -P httpd_unified 1",
      "sudo apachectl start",
      "sudo systemctl enable httpd",
      "sudo apachectl configtest",
      "sudo firewall-offline-cmd --add-port=80/tcp",
      "sudo firewall-cmd --permanent --zone=public --add-service=http",
      "sudo firewall-cmd --reload",
      "sudo bash -c 'echo This is compute test page from 01 >> /var/www/html/index.html'",
    ]

    connection {
      type        = "ssh"
      user        = "opc"
      private_key = file("~/.ssh/demokey") # Adjust path to your private key
      host        = self.public_ip
    }
  }

}

resource "oci_core_instance" "web-02" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "Web-Server-02"
  shape               = var.instance_shape
  subnet_id           = oci_core_subnet.subnet.id
  fault_domain = "FAULT-DOMAIN-2"

  source_details {
    source_type             = "image"
    source_id               = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo setsebool -P httpd_can_network_connect 1",
      "sudo setsebool -P httpd_unified 1",
      "sudo apachectl start",
      "sudo systemctl enable httpd",
      "sudo apachectl configtest",
      "sudo firewall-offline-cmd --add-port=80/tcp",
      "sudo firewall-cmd --permanent --zone=public --add-service=http",
      "sudo firewall-cmd --reload",
      "sudo bash -c 'echo This is compute test page from 02 >> /var/www/html/index.html'",
    ]

    connection {
      type        = "ssh"
      user        = "opc"
      private_key = file("~/.ssh/demokey") # Adjust path to your private key
      host        = self.public_ip
    }
}



