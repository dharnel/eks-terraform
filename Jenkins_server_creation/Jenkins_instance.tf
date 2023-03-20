#get recent ami
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"] 
}

#create instances
resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
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
