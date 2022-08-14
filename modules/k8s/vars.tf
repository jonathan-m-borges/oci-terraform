variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "vcn_id" {}
variable "enpoint_subnet_id"{}
variable "lb_subnet_id"{}
variable "nodes_subnet_id"{}
variable "node_pool_shape"{}
variable "node_pool_node_shape_config_ocpus" {}
variable "node_pool_node_shape_config_memory_in_gbs" {}
variable "num_pool_workers" {}


variable "image_operating_system" {
  default     = "Oracle Linux"
  description = "The OS/image installed on all nodes in the node pool."
}

variable "image_operating_system_version" {
  default     = "7.9"
  description = "The OS/image version installed on all nodes in the node pool."
}

variable "network_cidrs" {
  type = map(string)

  default = {
    PODS-CIDR                     = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR       = "10.96.0.0/16"
  }
}