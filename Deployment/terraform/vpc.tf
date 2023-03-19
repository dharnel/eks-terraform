#create vpc 
resource "aws_vpc" "my_custom_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    name = "custom_vpc"
  }
}

resource "aws_vpc_dhcp_options" "dhcpos" {
    domain_name = "${var.region}.compute.internal"
    domain_name_servers = ["AmazonProvidedDNS"]
}