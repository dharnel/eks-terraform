#create subnets
resource "aws_subnet" "private_az1" {
  vpc_id     = aws_vpc.my_custom_vpc.id
  cidr_block = var.public_ip_address[0]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    Name = "private-az1-${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id     = aws_vpc.my_custom_vpc.id
  cidr_block = var.public_ip_address[3]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.azs.names, 1)

  tags = {
    Name = "private-az1-${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public_az1" {
  vpc_id     = aws_vpc.my_custom_vpc.id
  cidr_block = var.public_ip_address[1]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.azs.names, 0)  

  tags = {
    Name = "public-az1-${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "utility" {
  vpc_id     = aws_vpc.my_custom_vpc.id
  cidr_block = var.public_ip_address[2]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.azs.names, 1)  

  tags = {
    Name = "utility-Subnet-${var.cluster_name}"
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_custom_vpc.id
}


#create elastic ip for nat gateway
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_eip" "eip2" {
  vpc = true
}

#create NAT gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.utility.id
}

resource "aws_nat_gateway" "natgw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id = aws_subnet.public_az1.id
}

#create custom route table
resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.my_custom_vpc.id
  depends_on = [
    aws_nat_gateway.natgw
  ]
  route {
    cidr_block = var.general_internet_ip
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "private_route_table_for_az1"
  }
}

resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.my_custom_vpc.id
  depends_on = [
    aws_nat_gateway.natgw2
  ]
  route {
    cidr_block = var.general_internet_ip
    gateway_id = aws_nat_gateway.natgw2.id
  }

  tags = {
    Name = "private_route_table_for_az2"
  }
}

resource "aws_route_table" "public_az1" {
  vpc_id = aws_vpc.my_custom_vpc.id

  route {
    cidr_block = var.general_internet_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table_for_az2"
  }
}

resource "aws_route_table" "utility" {
  vpc_id = aws_vpc.my_custom_vpc.id

  route {
    cidr_block = var.general_internet_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table_for_az2"
  }
}

#associate route table with public subnets
resource "aws_route_table_association" "private_for_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_az1.id
  depends_on = [
    aws_subnet.private_az1
  ]
}

resource "aws_route_table_association" "private_for_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_az2.id
  depends_on = [
    aws_subnet.private_az2
  ]
}

resource "aws_route_table_association" "public_for_az2" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_az1.id
  depends_on = [
    aws_subnet.public_az1
  ]
}

resource "aws_route_table_association" "utility" {
  subnet_id      = aws_subnet.utility.id
  route_table_id = aws_route_table.utility.id
  depends_on = [
    aws_subnet.utility
  ]
}