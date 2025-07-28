# Outputs for important resource endpoints and names

# The public endpoint for the S3 static website (useful for testing or troubleshooting)
output "s3_website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

# The domain name of the CloudFront distribution (useful for DNS configuration and testing)
output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

# The name of the Route53 hosted zone (useful for verification and management)
output "route53_zone_name" {
  description = "Route53 hosted zone name"
  value       = aws_route53_zone.main.name
}

# The nameservers for the Route53 hosted zone (needed for domain registrar configuration)
output "route53_nameservers" {
  description = "Route53 nameservers for domain configuration"
  value       = aws_route53_zone.main.name_servers
}

# The CloudFront distribution ID (needed for GitHub Actions)
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cdn.id
} 