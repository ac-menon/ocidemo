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
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
    user_data           = base64encode(var.user-data)
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
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
    user_data           = base64encode(var.user-data)
  }

}

variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '############# start cmds  ###############'
echo '#############  end cmds  ###############'
EOF

}

