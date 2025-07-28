# Route53 DNS configuration for the website

# Create a hosted zone for the main domain
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Certificate validation not needed since we're using existing certificate

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