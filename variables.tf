variable "vpc_name" {
  type        = string
  description = "The name of VPC in aws"
}

variable "vpc_cidr" {
  type        = string
  description = "The cidr block of vpc to be created"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "The cidr block of public subnet inside the vpc"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "The cidr block of private subnet inside the vpc"
}

variable "us_availability_zone" {
  type        = list(string)
  description = "The availibility zones to deploy resources"
}

variable "public_key" {
  type        = string
  description = "Public key value of local machine for ssh to jenkins ec2 server"
}

variable "ec2_jenkins_instance_type" {
  type        = string
  description = "The instance type of jenkins ec2 server"
}


variable "jenkins_domain_name" {
  type = string
description = "The domain name of jenkins server"
  }