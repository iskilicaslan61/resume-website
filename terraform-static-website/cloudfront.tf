# CloudFront Distribution for static website
resource "aws_cloudfront_distribution" "cdn" {
  # The S3 static website endpoint as the origin
  origin {
    domain_name = aws_s3_bucket.website.website_endpoint
    origin_id   = "s3-website"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true  # Enable the distribution
  is_ipv6_enabled     = true  # Enable IPv6 support
  default_root_object = "index.html"  # Default file to serve

  # Alternate domain names (CNAMEs) for your distribution
  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]  # Only allow GET and HEAD requests
    cached_methods   = ["GET", "HEAD"]  # Only cache GET and HEAD requests
    target_origin_id = "s3-website"      # Reference to the origin block above

    # Redirect all HTTP requests to HTTPS for security
    viewer_protocol_policy = "redirect-to-https"

    # Use AWS Managed CachingOptimized policy for efficient caching
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"  # Managed-CachingOptimized
  }

  # Error page configuration for SPA routing
  custom_error_response {
    error_code         = 404
    response_code      = "200"
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = "200"
    response_page_path = "/index.html"
  }

  # Use the lowest cost edge locations (US, Canada, Europe)
  price_class = "PriceClass_100"

  # SSL/TLS certificate settings for HTTPS
  viewer_certificate {
    acm_certificate_arn      = local.certificate_arn
    ssl_support_method       = "sni-only"  # Use SNI for SSL
    minimum_protocol_version = "TLSv1.2_2021"  # Enforce modern TLS
  }

  # No geo restrictions (available globally)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
} 