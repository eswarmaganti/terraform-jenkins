variable "domain_name" {}
variable "aws_lb_dns_name" {}
variable "aws_lb_zone_id" {}

# Outputs
output "hosted_zone_id" {
    value = data.aws_route53_zone.jenkins_hosted_zone.zone_id
}


data "aws_route53_zone" "jenkins_hosted_zone" {
    name = "eswarmaganti.com"
    private_zone = false
}


resource "aws_route53_record" "jenkins_record" {
    zone_id = data.aws_route53_zone.jenkins_hosted_zone.zone_id
    name = var.domain_name
    type = "A"
    alias {
        name = var.aws_lb_dns_name
        zone_id = var.aws_lb_zone_id
        evaluate_target_health = true
    }
}
