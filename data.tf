data "ibm_is_ssh_key" "project" {
  name = "hyperion-${var.region}"
}

data "ibm_is_vpc" "project" {
  name = var.vpc_name
}

data "ibm_resource_group" "project" {
  name = var.resource_group
}

data "ibm_resource_instance" "dns" {
  name              = var.pdns_instance
  resource_group_id = data.ibm_resource_group.project.id
}

data "ibm_is_zones" "region" {
  region = var.region
}

data "ibm_is_images" "public" {
  visibility = "public"
}
