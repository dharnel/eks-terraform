variable "access_key" {
    type = string
    sensitive = true
    default = "AKIATBF5UWBQHVDPQUUV"
}

variable "secret_key" {
    type = string
    sensitive = true
    default = "RZxf89DMWSLzCtDDWkZqH9zGwZ/UOSdYxLK/P7o7"
}

variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "general_internet_ip" {
    type = string
    default = "0.0.0.0/0"
}

variable "public_ip_address" {
    type = list(string)
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24","10.0.4.0/24"]
}

variable "instance" {
    type = string
    default = "t2.micro"
}