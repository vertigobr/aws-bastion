resource "aws_key_pair" "generated_key" {
  key_name   = "bastion_key"
  public_key = file("bastion_kp.pub")
  tags = {
  name = "Bastion"
  }
}
resource "aws_security_group" "web_security_group" {
  name        = "bastion_SG"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.bastion_vpc.id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
  Name = "Bastion"
  }
}

resource "aws_security_group" "db_security_group" {
  name = "db_bastion_SG"
  vpc_id      = aws_vpc.bastion_vpc.id
  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    security_groups = ["${aws_security_group.web_security_group.id}"]
  }
  tags = {
  name = "Bastion"
  }
}