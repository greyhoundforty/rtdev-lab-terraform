resource "ibm_dns_zone" "project" {
  name        = var.zone_name
  instance_id = data.ibm_resource_instance.dns.guid
}

resource "ibm_dns_permitted_network" "project" {
  instance_id = data.ibm_resource_instance.dns.guid
  zone_id     = ibm_dns_zone.project.zone_id
  vpc_crn     = data.ibm_is_vpc.project.crn
  type        = "vpc"
}

module "bastion_box" {
  source  = "we-work-in-the-cloud/vpc-bastion/ibm"
  version = "0.0.7"

  create_public_ip     = true
  allow_ssh_from       = "0.0.0.0/0"
  name                 = "${var.name}-bastion"
  resource_group_id    = data.ibm_resource_group.project.id
  vpc_id               = data.ibm_is_vpc.project.id
  subnet_id            = data.ibm_is_vpc.project.subnets[0].id
  ssh_key_ids          = [data.ibm_is_ssh_key.project.id]
  security_group_rules = var.security_group_rules
  tags                 = concat(var.tags)
}

resource "ibm_dns_resource_record" "bastion" {
  depends_on  = [module.bastion_box]
  instance_id = data.ibm_resource_instance.dns.guid
  zone_id     = ibm_dns_zone.project.zone_id
  type        = "A"
  name        = "${var.name}-bastion"
  rdata       = module.bastion_box.bastion_private_ip
  ttl         = 3600
}

module "ubuntu_box" {
  source            = "./instance"
  vpc_id            = data.ibm_is_vpc.project.id
  subnet_id         = data.ibm_is_vpc.project.subnets[0].id
  ssh_keys          = [data.ibm_is_ssh_key.project.id]
  resource_group_id = data.ibm_resource_group.project.id
  name              = "${var.name}-ubuntu20"
  os_image          = var.os_image
  dns_zone          = ibm_dns_zone.project.zone_id
  zone              = data.ibm_is_zones.region.zones[0]
  pdns_instance     = data.ibm_resource_instance.dns.guid
  security_groups   = [module.bastion_box.bastion_maintenance_group_id]
  tags              = concat(var.tags)
  allow_ip_spoofing = false
}

module "centos_box" {
  source            = "./instance"
  vpc_id            = data.ibm_is_vpc.project.id
  subnet_id         = data.ibm_is_vpc.project.subnets[0].id
  ssh_keys          = [data.ibm_is_ssh_key.project.id]
  resource_group_id = data.ibm_resource_group.project.id
  name              = "${var.name}-centos8"
  os_image          = "ibm-centos-8-3-minimal-amd64-3"
  dns_zone          = ibm_dns_zone.project.zone_id
  zone              = data.ibm_is_zones.region.zones[0]
  pdns_instance     = data.ibm_resource_instance.dns.guid
  security_groups   = [module.bastion_box.bastion_maintenance_group_id]
  tags              = concat(var.tags)
  allow_ip_spoofing = false
}

module "rhel_box" {
  source            = "./instance"
  vpc_id            = data.ibm_is_vpc.project.id
  subnet_id         = data.ibm_is_vpc.project.subnets[0].id
  ssh_keys          = [data.ibm_is_ssh_key.project.id]
  resource_group_id = data.ibm_resource_group.project.id
  name              = "${var.name}-rhel8-3"
  os_image          = "ibm-redhat-8-3-minimal-amd64-3"
  dns_zone          = ibm_dns_zone.project.zone_id
  zone              = data.ibm_is_zones.region.zones[0]
  pdns_instance     = data.ibm_resource_instance.dns.guid
  security_groups   = [module.bastion_box.bastion_maintenance_group_id]
  tags              = concat(var.tags)
  allow_ip_spoofing = false
}

module "debian_box" {
  source            = "./instance"
  vpc_id            = data.ibm_is_vpc.project.id
  subnet_id         = data.ibm_is_vpc.project.subnets[0].id
  ssh_keys          = [data.ibm_is_ssh_key.project.id]
  resource_group_id = data.ibm_resource_group.project.id
  name              = "${var.name}-deb10"
  os_image          = "ibm-debian-10-8-minimal-amd64-1"
  dns_zone          = ibm_dns_zone.project.zone_id
  zone              = data.ibm_is_zones.region.zones[0]
  pdns_instance     = data.ibm_resource_instance.dns.guid
  security_groups   = [module.bastion_box.bastion_maintenance_group_id]
  tags              = concat(var.tags)
  allow_ip_spoofing = false
}
