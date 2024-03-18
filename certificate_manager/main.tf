variable "domain_name" {
    
}
variable "hosted_zone_id" {
}



output "acm_certificate_arn" {
    value = aws_acm_certificate.jenkins_certificate.arn
}

resource "aws_acm_certificate" "jenkins_certificate" {
    domain_name = var.domain_name
    validation_method = "DNS"
    
    tags = {
        Name = "Jenkins Server Certificate"
    }
    lifecycle {
      create_before_destroy = false
    }
}

resource "aws_route53_record" "certificate_validation" {
    for_each = {
        for dvo in aws_acm_certificate.jenkins_certificate.domain_validation_options : dvo.domain_name =>
        {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }    
    }
    zone_id = var.hosted_zone_id
    name = each.value.name
    type = each.value.type
    records = [each.value.record]
    ttl = 60
}