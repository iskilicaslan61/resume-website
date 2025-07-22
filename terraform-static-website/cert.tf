# ACM certificate configuration for HTTPS support on CloudFront

# This resource requests a wildcard SSL/TLS certificate from AWS Certificate Manager (ACM).
# The certificate will be valid for both the main domain (ibrahimkilicaslan.click) and all subdomains (*.ibrahimkilicaslan.click).
# Note: For CloudFront, the certificate MUST be created in the us-east-1 region, regardless of where your other resources are.
resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method = "DNS"
}

# This resource validates the ACM certificate by creating the required DNS records in Route53.
# Terraform will automatically create the necessary CNAME records for validation.
# Once validated, the certificate can be used by CloudFront for HTTPS on all your domains and subdomains.
resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}