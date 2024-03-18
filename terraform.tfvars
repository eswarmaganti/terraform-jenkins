vpc_name = "devops-project-vpc"
vpc_cidr = "10.0.0.0/16"

public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]

us_availability_zone = ["us-east-1a", "us-east-1b"]

public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIRvireUs9syXbAolg/O4Ssqs7LYUFnFu9KhKfmufc/d rabbu@RABBUNI"

ec2_jenkins_instance_type = "t2.medium"

jenkins_domain_name = "jenkins.eswarmaganti.com"