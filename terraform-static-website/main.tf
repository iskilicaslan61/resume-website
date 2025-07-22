# Main Terraform configuration file
# This file defines providers used throughout the project.
# It is the entry point for your Terraform infrastructure as code.

# AWS provider for main resources (S3, Route53, etc.)
# The region is set using the aws_region variable (see variables.tf).
provider "aws" {
  region = var.aws_region
}

# AWS provider for us-east-1 region (required for ACM certificates used by CloudFront)
# CloudFront only supports certificates from us-east-1, regardless of where your other resources are.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# All variables (such as aws_region and domain_name) are defined in variables.tf for clarity and reusability.
# All resource definitions (S3, Route53, ACM, CloudFront, etc.) are split into separate .tf files for modularity and easier management.
# This main.tf file is intentionally kept minimal to serve as a central entry point and to avoid duplication. 