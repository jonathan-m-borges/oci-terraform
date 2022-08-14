resource "oci_core_route_table" "oke_private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-private-route-table"

  route_rules {
    description       = "Traffic to the internet"
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.oke_nat_gateway.id
  }
  route_rules {
    description       = "Traffic to OCI services"
    destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.oke_service_gateway.id
  }
}


resource "oci_core_route_table" "oke_public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.oke_vcn.id
  display_name   = "oke-public-route-table"

  route_rules {
    description       = "Traffic to/from internet"
    destination       = lookup(var.network_cidrs, "ALL-CIDR")
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.oke_internet_gateway.id
  }
}



