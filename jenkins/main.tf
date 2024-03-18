# Module inmput variables
variable "subnet_id" {}
variable "instance_type" {}
variable "public_key" {}
variable "enable_public_ip" {}
variable "security_groups" {}
variable user_data_jenkins {}


#Outputs
output "jenkins_ec2_instance_id" {
    value = aws_instance.jenkins_ec2_instance.id
}

output "jenkins_ec2_public_ip" {
    value = aws_instance.jenkins_ec2_instance.public_ip
}
output "jenkins_ec2_private_ip" {
    value = aws_instance.jenkins_ec2_instance.private_ip
}
output "jenkins_ec2_public_dns" {
    value = aws_instance.jenkins_ec2_instance.public_dns
}


# Setup the ec2 instance for jenkins server
resource "aws_instance" "jenkins_ec2_instance" {
    ami = data.aws_ami.ec2_jenkins_ami.id
    instance_type = var.instance_type
    user_data = var.user_data_jenkins
    key_name = "jenkins_key"
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_groups
    associate_public_ip_address = var.enable_public_ip
    tags = {
        Name  = "DevOps Jenkins Ec2 Instance"
    }
    metadata_options {
      http_endpoint = "enabled"
      http_tokens = "required"
    }
}

# creating the key to ssh into jenkins ec2
resource "aws_key_pair" "jenkins_ec2_instance_publickey" {
    key_name = "jenkins_key"
    public_key = var.public_key
}