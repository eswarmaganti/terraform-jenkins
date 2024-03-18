variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "us_availability_zone" {}


# outputs
output "devops_vpc_id" {
  description = "The ID of DevOps VPC"
  value       = aws_vpc.devops_project_vpc.id
}

output "vpc_public_subnets" {
  description = "A list of public subnet id's"
  value       = [for subnet in aws_subnet.devops_vpc_public_subnets : subnet.id]
}



# Setup VPC
resource "aws_vpc" "devops_project_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# Setup Public Subnets
resource "aws_subnet" "devops_vpc_public_subnets" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.devops_project_vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.us_availability_zone, count.index)
  tags = {
    Name = "DevOps VPC Public Subnet - ${count.index}"
  }
}

# Setup Private Subnets
resource "aws_subnet" "devops_vpc_private_subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.devops_project_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.us_availability_zone, count.index)
  tags = {
    Name = "DevOps VPC Private Subnet - ${count.index}"
  }
}

# Setup internet gateway to enable the traffic from public internet to public subnet
resource "aws_internet_gateway" "devops_vpc_igw" {
  vpc_id = aws_vpc.devops_project_vpc.id
  tags = {
    Name = "DevOps VPC IGW"
  }
}

# Setup route table and its associations for public subnet
resource "aws_route_table" "devops_public_route_table" {
  vpc_id = aws_vpc.devops_project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_vpc_igw.id
  }
  tags = {
    Name = "DevOps Public Route Table"
  }
}

# creating the association b/w the public subnet and route table
resource "aws_route_table_association" "devops_public_route_table_association" {
  count          = length(aws_subnet.devops_vpc_public_subnets)
  subnet_id      = aws_subnet.devops_vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.devops_public_route_table.id
}


# Setup route table for private subnet
resource "aws_route_table" "devops_private_route_table" {
  vpc_id = aws_vpc.devops_project_vpc.id
  tags = {
    Name = "DevOps Private Route Table"
  }
}


# Creating route table and private subnet associations
resource "aws_route_table_association" "devops_private_route_table_association" {
  count          = length(aws_subnet.devops_vpc_private_subnets)
  subnet_id      = aws_subnet.devops_vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.devops_private_route_table.id
}
