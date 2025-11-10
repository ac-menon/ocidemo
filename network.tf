
resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  dns_label      = var.vcn_dns_label
  display_name   = var.vcn_dns_label
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}_igw"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# Public Route Table
resource "oci_core_route_table" "publicRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.vcn_dns_label}_pubRT"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_subnet" "subnet" {
  availability_domain = ""
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_virtual_network.vcn.id
  cidr_block          = cidrsubnet(var.vcn_cidr, 8, 1)
  display_name        = var.dns_label
  dns_label           = var.dns_label
  route_table_id      = oci_core_route_table.publicRT.id
  security_list_ids   = [oci_core_security_list.securitylist.id]
}

resource "oci_core_security_list" "securitylist" {
  display_name   = "SL_public"
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
}
