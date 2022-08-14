#VCN

resource "oci_core_virtual_network" "oke_vcn" {
  cidr_block     = lookup(var.network_cidrs, "VCN-CIDR")
  compartment_id = var.compartment_ocid
  display_name   = "workshop-vcn"
  dns_label      = "workshopvcn"
}


# SUBNETS

resource "oci_core_subnet" "oke_k8s_endpoint_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "ENDPOINT-SUBNET-REGIONAL-CIDR")
  compartment_id             = var.compartment_ocid
  display_name               = "oke-k8s-endpoint-subnet"
  dns_label                  = "okek8snendpoint"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_endpoint_security_list.id]
}


resource "oci_core_subnet" "oke_nodes_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "SUBNET-REGIONAL-CIDR")
  compartment_id             = var.compartment_ocid
  display_name               = "oke-nodes-subnet"
  dns_label                  = "okenodesnnodes"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = true 
  route_table_id             = oci_core_route_table.oke_private_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_nodes_security_list.id]
}

resource "oci_core_subnet" "oke_lb_subnet" {
  cidr_block                 = lookup(var.network_cidrs, "LB-SUBNET-REGIONAL-CIDR")
  compartment_id             = var.compartment_ocid
  display_name               = "oke-lb-subnet"
  dns_label                  = "okelbsnlb"
  vcn_id                     = oci_core_virtual_network.oke_vcn.id
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.oke_public_route_table.id
  dhcp_options_id            = oci_core_virtual_network.oke_vcn.default_dhcp_options_id
  security_list_ids          = [oci_core_security_list.oke_lb_security_list.id]
}