variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
  default = "my-K8s"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "general_internet_ip" {
    type = string
    default = "0.0.0.0/0"
}

variable "public_ip_address" {
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
}

variable "private_ip_address" {
    type = list(string)
    default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "private_ip_address_nic" {
    type = list(string)
    default = ["10.0.1.10","10.0.2.200"]
}

variable "ipv6_ip" {
    type = string
    default = "::/0"
}

variable "ami_detail" {
    type = string
    default = "ami-0d09654d0a20d3ae2"
}

variable "instance" {
    type = string
    default = "t2.medium"
}

variable "domain_name" {
    type = string
    default = "niellaravelapp.me"
}

variable "myapp1_site_domain" {
    type = string
    default = "myapp1.niellaravelapp.me"
}

variable "myapp2_site_domain" {
    type = string
    default = "myapp2.niellaravelapp.me"
}

variable "monitoring_site_domain" {
    type = string
    default = "monitoring.niellaravelapp.me"
}



variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSWorkshop"
    "Environment" = "Development"
    "Owner"       = "Ashish Patel"
  }
}
