# ACM certificate configuration for HTTPS support on CloudFront

# Use existing certificate that's already validated
data "aws_acm_certificate" "cert" {
  provider = aws.us_east_1
  domain   = var.domain_name
  statuses = ["ISSUED"]
  most_recent = true
}

# No validation needed since certificate is already issued
locals {
  certificate_arn = data.aws_acm_certificate.cert.arn
}