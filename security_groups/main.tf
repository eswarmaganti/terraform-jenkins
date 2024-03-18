variable "ec2_security_group_name" {

}

variable "jenkins_security_group_name" {

}
variable "vpc_id" {

}


# Outputs
output "ec2_security_group_http_ssh" {
  description = "The ID of HTTP security group"
  value       = aws_security_group.ec2_security_group_http_ssh.id
}
output "ec2_security_group_jenkins" {
  description = "The ID of HTTP security group"
  value       = aws_security_group.ec2_security_group_jenkins.id
}


resource "aws_security_group" "ec2_security_group_http_ssh" {
  vpc_id = var.vpc_id
  name   = var.ec2_security_group_name

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP requests from public internet"
    protocol    = "tcp"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS requests from public internet"
    protocol    = "tcp"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH to access the server"
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow the resource to access the public internet"
  }

  tags = {
    Name = var.ec2_security_group_name
  }
}


resource "aws_security_group" "ec2_security_group_jenkins" {
  vpc_id = var.vpc_id
  name   = var.jenkins_security_group_name
  ingress {
    description = "Allow port 8080 to access the jenkins server"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.ec2_security_group_name
  }
}
