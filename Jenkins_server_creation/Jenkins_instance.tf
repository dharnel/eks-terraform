#get recent ami
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

#create instances
resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance
  security_groups    = [aws_security_group.jenkins_server.id]
  key_name       =  "instance-key"
  subnet_id = aws_subnet.public_az1.id
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  user_data = file("jenkins_server_script.sh")

  tags = {
    Name = "jenkins_server"
  }
}