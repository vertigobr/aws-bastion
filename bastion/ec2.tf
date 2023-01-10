### BASTION_EC2 ####
resource "aws_instance" "bastion_ec2" {
  ami                    = var.image
  security_groups = [aws_security_group.web_security_group.id]
  instance_type          = var.host
  subnet_id = aws_subnet.public_subnet.id
  key_name = aws_key_pair.generated_key.key_name
  tags = {
  name = "Bastion"
  }
}
### Elastic IP ###
resource "aws_eip" "bastionip" {
    instance = aws_instance.bastion_ec2.id
    vpc = true
    tags = {
    name = "Bastion"
  }
}
#### EBS ###
resource "aws_ebs_volume" "ebs_bastion" {
  availability_zone = var.availabilityZone
  size              = var.size_ebs

  tags = {
    Name = "Bastion"
  }
}
### Attach Volume ####
resource "aws_volume_attachment" "volume_bastion" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_bastion.id
  instance_id = aws_instance.bastion_ec2.id
}

