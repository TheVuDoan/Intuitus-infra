variable "environment" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_availability_zone" {
  default = "us-east-1a"
}
