variable "vpc_id" {}
variable "lb_target_group_port" {}
variable "lb_target_group_protocol" {}
variable "lb_target_group_name" {}
variable "ec2_instance_id" {}

# Outputs
output "lb_target_group_id" {
    value = aws_lb_target_group.lb_target_group.id
}

output "lb_target_group_arn" {
 value = aws_lb_target_group.lb_target_group.arn    
}


# setup the application load balencer target group
resource "aws_lb_target_group" "lb_target_group" {
    name = var.lb_target_group_name
    port = var.lb_target_group_port
    protocol = var.lb_target_group_protocol
    vpc_id = var.vpc_id
    
    health_check {
        enabled = true
        path = "/login"
        interval = 20
        port = var.lb_target_group_port
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 2
        matcher = "200"
    }
    tags = {
    Name="Jenkins Server Application Loadbalencer Target Group"    
    }
}

# create the load balencer target group association to jenkins ec2 instance
resource "aws_alb_target_group_attachment" "lb_target_group_attachment" {
    target_id = var.ec2_instance_id
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    port = var.lb_target_group_port
}