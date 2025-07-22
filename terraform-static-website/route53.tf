# Route53 DNS configuration for the website

# Create a hosted zone for the main domain
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# This resource requests a wildcard SSL/TLS certificate from AWS Certificate Manager (ACM).
locals {
  unique_cert_validations = distinct([
    for dvo in aws_acm_certificate.cert.domain_validation_options : {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  ])
}

# This resource validates the ACM certificate by creating the required DNS records in Route53.
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Create alias A records for each domain/subdomain to point to CloudFront
# IMPORTANT: All DNS records are managed by Terraform. Delete any manual records before applying.
resource "aws_route53_record" "cloudfront_alias" {
  for_each = toset(var.aliases)
  zone_id = aws_route53_zone.main.zone_id
  name    = each.value
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
} 