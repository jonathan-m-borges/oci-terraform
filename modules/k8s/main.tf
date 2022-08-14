resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = "v1.20.8"
  name               = "oke-workshop"
  vcn_id             =  var.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.enpoint_subnet_id
  }
  options {
    service_lb_subnet_ids = [var.lb_subnet_id]
    kubernetes_network_config {
      services_cidr = lookup(var.network_cidrs, "KUBERNETES-SERVICE-CIDR")
      pods_cidr     = lookup(var.network_cidrs, "PODS-CIDR")
    }
  }
}


resource "oci_containerengine_node_pool" "oke_node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = "v1.20.8"
  name               = "nodepool1"
  node_shape         = var.node_pool_shape

  node_config_details {
    dynamic "placement_configs" {
      for_each = data.oci_identity_availability_domains.ADs.availability_domains

      content {
        availability_domain = placement_configs.value.name
        subnet_id           = var.nodes_subnet_id
      }
    }
    size = var.num_pool_workers
  }

  dynamic "node_shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      ocpus         = var.node_pool_node_shape_config_ocpus
      memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = lookup(data.oci_core_images.node_pool_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  initial_node_labels {
    key   = "name"
    value = "nodepool1"
  }
}

locals {
  is_flexible_node_shape = contains(local.compute_flexible_shapes, var.node_pool_shape)
}

locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex"
  ]
}