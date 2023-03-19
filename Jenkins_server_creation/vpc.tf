#create vpc
resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    name = "jenkins_vpc"
  }
}

#create subnet
resource "aws_subnet" "public_az1" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = var.public_ip_address[1]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.azs.names, 0)  

  tags = {
    Name = "Jenkins_server_subnet"
  }
}

#create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
}

#create route table
resource "aws_route_table" "public_az1" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = var.general_internet_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table_for_az1"
  }
}

#associate route table with subnet
resource "aws_route_table_association" "public_for_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_az1.id
  depends_on = [
    aws_subnet.public_az1
  ]
} 

#security group
resource "aws_security_group" "jenkins_server" {
  name        = "Jenkins server"
  description = "allow required traffic to jenkins server"
  vpc_id      = aws_vpc.jenkins_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.general_internet_ip]
  }

  ingress {
    description = "jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.general_internet_ip]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = [var.general_internet_ip]
  }

  tags = {
    Name = "Jenkins_server"
  }
}