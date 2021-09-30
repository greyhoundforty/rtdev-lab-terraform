output "bastion_ip" {
  value = module.bastion_box.bastion_public_ip
}

output "images" {
  value = jsonencode(data.ibm_is_images.public.images[*].os)
}
