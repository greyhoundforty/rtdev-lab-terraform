variable "vpc_name" {}
variable "name" {}

#variable "ssh_key" {}

variable "os_image" {
  type        = string
  description = "OS image used for compute instance."
  default     = "ibm-ubuntu-20-04-2-minimal-amd64-1"
}

variable "pdns_instance" {
  type        = string
  description = "Name of the existing Private DNS instance."
}

variable "tags" {
  default = ["owner:ryantiffany"]
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group to use for deployed resources."
}

variable "region" {
  type        = string
  description = "Name of the region to use for deployed resources"
}

variable "zone_name" {}
