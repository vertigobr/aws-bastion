### REDE

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "bastion_vpc" {
  cidr_block = var.vcpCIDRblock
}
  

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.bastion_vpc.id
  cidr_block = var.publicsCIDRblock
  availability_zone = var.availabilityZone
  tags = {
    Name = "Bastion"
  }
}
resource "aws_subnet" "private_subnet" {
  count = var.subnet_count.private
  vpc_id = aws_vpc.bastion_vpc.id
  cidr_block = var.privatesCIDRblock[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Bastion"
  }
}
resource "aws_db_subnet_group" "subnetgroup_banco" {
    name = "subnetgroup_banco"
    subnet_ids = [ for subnet in aws_subnet.private_subnet: subnet.id ]
    tags = {
    Name = "Bastion"
  }
}

resource "aws_internet_gateway" "bastion-igw" {
  vpc_id = aws_vpc.bastion_vpc.id
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.bastion_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bastion-igw.id
  }
}

resource "aws_route_table_association" "public_ra" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.bastion_vpc.id
}
  resource "aws_route_table_association" "private_ra" {
    count = var.subnet_count.private
    route_table_id = aws_route_table.private_rt.id
    subnet_id = aws_subnet.private_subnet[count.index].id
}


 