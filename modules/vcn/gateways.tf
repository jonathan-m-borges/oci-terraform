resource "oci_core_nat_gateway" "oke_nat_gateway" {
  block_traffic  = "false"
  compartment_id = var.compartment_ocid
  display_name   = "oke-nat-gateway"
  vcn_id         = oci_core_virtual_network.oke_vcn.id
}

resource "oci_core_internet_gateway" "oke_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "oke-internet-gateway"
  enabled        = true
  vcn_id         = oci_core_virtual_network.oke_vcn.id
}

resource "oci_core_service_gateway" "oke_service_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "oke-service-gateway"
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }
}