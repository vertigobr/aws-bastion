module "bastion" {
  source = "./bastion"
  
  image = local.config.bastion.image
  host = local.config.bastion.host
  keyname = local.config.bastion.keyname
  availabilityZone = "${data.aws_availability_zones.available.names[0]}"
  vcpCIDRblock = local.config.rede.cidr_block
  subnet_count = {
    "public" = 1,
    "private"= 2
   }
}

output "ec2_instance_type" {
    value = module.bastion.ec2_instance_type
}
output "ec2_public_ip" {
     description = "ssh ssh -i ./bastion_kp ec2-user@{ec2_public_ip}"
     value = module.bastion.ec2_public_ip

}

