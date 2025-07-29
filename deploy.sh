#!/bin/bash

# Resume Website AWS Deployment Script
# This script deploys AWS infrastructure with Terraform

set -e  # Stop script on error

echo "🚀 Resume Website AWS Deployment Script"
echo "========================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# AWS credentials check
check_aws_credentials() {
    print_info "Checking AWS credentials..."
    
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials not found!"
        echo "Please do one of the following:"
        echo "1. Run 'aws configure' command"
        echo "2. Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables"
        echo "3. Install AWS CLI: https://aws.amazon.com/cli/"
        exit 1
    fi
    
    print_success "AWS credentials verified"
}

# Terraform check
check_terraform() {
    print_info "Checking Terraform..."
    
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform not found!"
        echo "Please install Terraform: https://terraform.io/downloads"
        exit 1
    fi
    
    print_success "Terraform found: $(terraform version | head -n1)"
}

# Change to Terraform directory
cd_terraform_dir() {
    if [ ! -d "terraform-static-website" ]; then
        print_error "terraform-static-website directory not found!"
        exit 1
    fi
    
    cd terraform-static-website
    print_info "Changed to Terraform directory: $(pwd)"
}

# Terraform init
terraform_init() {
    print_info "Initializing Terraform..."
    
    if [ ! -d ".terraform" ]; then
        terraform init
        print_success "Terraform initialized"
    else
        print_info "Terraform already initialized"
    fi
}

# Terraform plan
terraform_plan() {
    print_info "Creating Terraform plan..."
    
    terraform plan -out=tfplan
    print_success "Terraform plan created"
}

# Terraform apply
terraform_apply() {
    print_info "Applying Terraform..."
    
    if [ -f "tfplan" ]; then
        terraform apply tfplan
    else
        terraform apply
    fi
    
    print_success "Terraform applied successfully!"
}

# Show outputs
show_outputs() {
    print_info "Infrastructure outputs:"
    echo ""
    
    echo "🌐 S3 Website Endpoint:"
    terraform output s3_website_endpoint
    
    echo ""
    echo "☁️  CloudFront Domain:"
    terraform output cloudfront_domain_name
    
    echo ""
    echo "🔗 Route53 Zone Name:"
    terraform output route53_zone_name
    
    echo ""
    echo "📡 Route53 Nameservers (for Domain Registrar):"
    terraform output route53_nameservers
    
    echo ""
    echo "🆔 CloudFront Distribution ID (for GitHub Secrets):"
    terraform output cloudfront_distribution_id
}

# Domain registrar instructions
show_domain_instructions() {
    echo ""
    print_warning "DOMAIN REGISTRAR CONFIGURATION REQUIRED!"
    echo "================================================"
    echo ""
    echo "To point your ismailkilicaslan.de domain to AWS Route53:"
    echo ""
    echo "1. Copy the Route53 nameservers above"
    echo "2. Go to your domain registrar's DNS management panel"
    echo "3. Replace nameservers with the values above"
    echo "4. Changes can take 24-48 hours to propagate"
    echo ""
    echo "Required secrets for GitHub Actions:"
    echo "- AWS_ACCESS_KEY_ID"
    echo "- AWS_SECRET_ACCESS_KEY"
    echo "- CLOUDFRONT_DISTRIBUTION_ID (get from output above)"
    echo ""
    echo "See AWS_IAM_SETUP.md file for detailed setup."
}

# Main function
main() {
    echo ""
    
    # Checks
    check_aws_credentials
    check_terraform
    
    # Change to Terraform directory
    cd_terraform_dir
    
    # Terraform operations
    terraform_init
    terraform_plan
    
    echo ""
    print_warning "Do you want to continue? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        terraform_apply
        show_outputs
        show_domain_instructions
    else
        print_info "Deployment cancelled"
        exit 0
    fi
}

# Run script
main "$@" 