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

  metadata = {
    #ssh_authorized_keys = chomp(var.ssh_public_key)    
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    user_data           = base64encode(var.user-data-01)
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

  metadata = {
    #ssh_authorized_keys = chomp(var.ssh_public_key)
    ssh_authorized_keys = var.ssh_public_key != "" ? var.ssh_public_key : file(var.ssh_public_key_path)
    user_data           = base64encode(var.user-data-02)
  }

}

variable "user-data-01" {
  default = <<EOF
#!/bin/bash -x
echo '############# start cmds  ###############'
sudo yum install httpd -y
sudo apachectl start
sudo systemctl enable httpd
sudo apachectl configtest
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
sudo bash -c 'echo This is compute test page from 01 >> /var/www/html/index.html'
echo '#############  end cmds  ###############'
EOF

}

variable "user-data-02" {
  default = <<EOF
#!/bin/bash -x
echo '############# start cmds  ###############'
sudo yum install httpd -y
sudo apachectl start
sudo systemctl enable httpd
sudo apachectl configtest
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
sudo bash -c 'echo This is compute test page from 02 >> /var/www/html/index.html'
echo '#############  end cmds  ###############'
EOF

}

