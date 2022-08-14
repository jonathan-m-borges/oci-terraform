variable "tenancy_ocid" {}
variable "compartment_ocid" {}

variable "network_cidrs" {
  type = map(string)

  default = {
    VCN-CIDR                      = "10.20.0.0/16"
    SUBNET-REGIONAL-CIDR          = "10.20.10.0/24"
    LB-SUBNET-REGIONAL-CIDR       = "10.20.20.0/24"
    ENDPOINT-SUBNET-REGIONAL-CIDR = "10.20.0.0/28"
    ALL-CIDR                      = "0.0.0.0/0"
    PODS-CIDR                     = "10.244.0.0/16"
    KUBERNETES-SERVICE-CIDR       = "10.96.0.0/16"
  }
}