resource "ibm_is_instance" "instance" {
  name           = var.name
  vpc            = var.vpc_id
  zone           = var.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = var.ssh_keys
  resource_group = var.resource_group_id
  user_data      = file("${path.module}/init.yml")
  tags           = concat(var.tags, ["zone:${var.zone}", "os:${var.os_image}"])
  primary_network_interface {
    subnet            = var.subnet_id
    security_groups   = var.security_groups
    allow_ip_spoofing = var.allow_ip_spoofing != "" ? var.allow_ip_spoofing : false
  }
  boot_volume {
    name = "${var.name}-boot-volume"
  }
}

resource "ibm_dns_resource_record" "instance" {
  depends_on  = [ibm_is_instance.instance]
  instance_id = var.pdns_instance
  zone_id     = var.dns_zone
  type        = "A"
  name        = var.name
  rdata       = ibm_is_instance.instance.primary_network_interface[0].primary_ipv4_address
  ttl         = 3600
}
