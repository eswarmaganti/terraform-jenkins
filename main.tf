# Networking Custom Module

module "networking" {
  source               = "./networking"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  us_availability_zone = var.us_availability_zone
}

# Security Group Module
module "security_groups" {
  source                      = "./security_groups"
  ec2_security_group_name     = "DevOps Ec2 Security Group (Allow HTTP, HTTPS & SSH)"
  jenkins_security_group_name = "Jenkins Security Group (Allow PORT 8080)"
  vpc_id                      = module.networking.devops_vpc_id
}

# EC2 Server for Jenkins 
module "jenkins" {
  source           = "./jenkins"
  subnet_id        = element(module.networking.vpc_public_subnets, 0)
  instance_type    = var.ec2_jenkins_instance_type
  public_key       = var.public_key
  enable_public_ip = true
  security_groups  = [module.security_groups.ec2_security_group_http_ssh, module.security_groups.ec2_security_group_jenkins]
  user_data_jenkins = templatefile("./jenkins_runner_scripts/jenkins_install.sh",{})

}

# Load Balencer Target Group
module "lb_target_group" {
  source = "./load_balencer_target_group"
  vpc_id = module.networking.devops_vpc_id
  lb_target_group_port = 8080
  lb_target_group_protocol = "HTTP"
  lb_target_group_name = "jenkins-lb-target-group"
  ec2_instance_id = module.jenkins.jenkins_ec2_instance_id
}

# Application Load Balencer Setup
module "load_balencer" {
  source = "./load_balencer"
  lb_name="jenkins-application-loadbalencer"
  lb_type = "application"
  is_internal = false
  lb_security_groups = [module.security_groups.ec2_security_group_http_ssh]
  subnets = module.networking.vpc_public_subnets
  lb_target_group_arn = module.lb_target_group.lb_target_group_arn
  ec2_instance_id = module.jenkins.jenkins_ec2_instance_id
  lb_listner_port = 80 # which the lb will listen
  lb_listner_protocol = "HTTP"
  lb_https_listner_port = 443
  lb_https_listener_protocol = "HTTPS"
  lb_target_group_attachment_port = 8080
  acm_certificate_arn = module.certificate_manager.acm_certificate_arn
  }
  
  module "hosted_zone" {
    source = "./hosted_zone"
    aws_lb_zone_id = module.load_balencer.alb_zone_id
    aws_lb_dns_name = module.load_balencer.alb_public_dns
    domain_name = var.jenkins_domain_name
  }
  
  module "certificate_manager" {
    source = "./certificate_manager"
    domain_name = var.jenkins_domain_name
    hosted_zone_id = module.hosted_zone.hosted_zone_id
  }