terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_route53_zone" "this" {
  name              = var.domain_name
}

resource "aws_route53_record" "alias_records" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
      name                   = aws_cloudfront_distribution.frontend.domain_name
      zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
      evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "these" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "streamzen" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.these : record.fqdn]
}
