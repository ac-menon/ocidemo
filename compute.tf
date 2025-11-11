data "template_file" "user-data-01" {
  template = file("web-script01.sh")
}
data "template_file" "user-data-02" {
  template = file("web-script02.sh")
}

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
    user_data           = base64encode(data.template_file.user-data-01.rendered)
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
    user_data           = base64encode(data.template_file.user-data-02.rendered)
  }

}
