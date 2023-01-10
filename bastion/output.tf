output "ec2_instance_type" {
    value = aws_instance.bastion_ec2.instance_type
}
output "ec2_public_ip" {
     value = aws_eip.bastionip.public_ip
}