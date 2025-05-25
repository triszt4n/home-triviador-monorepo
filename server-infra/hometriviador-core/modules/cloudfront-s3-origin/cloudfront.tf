resource "aws_cloudfront_vpc_origin" "alb" {
  vpc_origin_endpoint_config {
    name                   = "vpc-origin"
    arn                    = var.alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only" # terminate SSL at ALB

    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
}

resource "aws_cloudfront_distribution" "frontend" {
  enabled = var.enable_distro
  staging = false
  comment = "distro-${var.environment}"
  aliases = [var.domain_name]

  origin {
    origin_id   = "vpc-origin"
    domain_name = var.alb_domain_name

    vpc_origin_config {
      vpc_origin_id = aws_cloudfront_vpc_origin.alb.id
    }
  }

  http_version        = "http2and3"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods        = local.allowed_methods_types.all
    cached_methods         = local.cached_methods_types.get_head
    compress               = true
    target_origin_id       = "vpc-origin"
    viewer_protocol_policy = "redirect-to-https"

    # Attached policies
    cache_policy_id          = data.aws_cloudfront_cache_policy.disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all.id
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.this.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
