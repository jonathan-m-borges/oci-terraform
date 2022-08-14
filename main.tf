
resource "oci_identity_dynamic_group" "devops_pipe_dg" {
  name           = "devops-pipe-dg"
  description    = "DevOps Pipeline Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "All {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_id}'}"
}

resource "oci_identity_policy" "devops_policies" {
  name           = "devops-compartment-policies"
  description    = "DevOps Compartment Policies"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow dynamic-group devops-pipe-dg to manage all-resources in compartment id ${var.compartment_id}"]

  depends_on = [oci_identity_dynamic_group.devops_pipe_dg]
}

resource "oci_ons_notification_topic" "devops_notification_topic" {
  compartment_id = var.compartment_id
  name           = "devops_notification_topic"
}


module "vcn" {
  source = "./modules/vcn"
  tenancy_ocid      = var.tenancy_ocid
  compartment_ocid  = var.compartment_id
}


module "k8s" {
  source = "./modules/k8s"
  tenancy_ocid = var.tenancy_ocid
  compartment_ocid  = var.compartment_id
  node_pool_shape = var.node_pool_shape
  node_pool_node_shape_config_ocpus = var.node_pool_node_shape_config_ocpus
  node_pool_node_shape_config_memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
  num_pool_workers = var.num_pool_workers
  vcn_id = module.vcn.oke_vcn_id
  enpoint_subnet_id = module.vcn.oke_k8s_endpoint_subnet_id
  lb_subnet_id = module.vcn.oke_lb_subnet_id
  nodes_subnet_id = module.vcn.oke_nodes_subnet_id
}


module "functions" {
  source = "./modules/functions"
  compartment_ocid  = var.compartment_id
  lb_subnet_id = module.vcn.oke_lb_subnet_id
  nodes_subnet_id = module.vcn.oke_nodes_subnet_id
}


