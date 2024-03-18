variable "lb_name" {}  
variable "lb_type" {}
variable "is_internal" {}
variable "lb_security_groups" {}
variable "subnets" {}
variable "lb_target_group_arn" {}
variable "ec2_instance_id" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {} 
variable "lb_https_listner_port" {}
variable "lb_https_listener_protocol" {}
variable "lb_target_group_attachment_port" {}

variable "acm_certificate_arn" {
  
}

output "alb_public_dns" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}


# Setup Application Load Balencer and Attach the Target Group to it
resource "aws_lb" "alb" {
    name = var.lb_name
    load_balancer_type = var.lb_type
    internal = var.is_internal
    security_groups = var.lb_security_groups
    subnets = var.subnets
    enable_deletion_protection = false
    tags = {
    Name = "Jenkins Server Application Loadbalencer"
    }  
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  port = var.lb_target_group_attachment_port
  target_id = var.ec2_instance_id
}


# Setup HTTP and HTTPS Listeners
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.lb_listner_port
  protocol = var.lb_listner_protocol
  
  default_action {
    type = "forward"
    target_group_arn = var.lb_target_group_arn
    }
}


resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.lb_https_listner_port
  protocol = var.lb_https_listener_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn = var.acm_certificate_arn
  default_action {
    type = "forward"
    target_group_arn = var.lb_target_group_arn
    }
}