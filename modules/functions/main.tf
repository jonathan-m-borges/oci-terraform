resource "oci_functions_application" "workshop_application" {
    #Required
    compartment_id = var.compartment_ocid
    display_name = "workshop-application"
    subnet_ids = [var.lb_subnet_id,var.nodes_subnet_id]
}