@echo off
setlocal enabledelayedexpansion

REM Resume Website AWS Deployment Script
REM This script deploys AWS infrastructure with Terraform

echo.
echo 🚀 Resume Website AWS Deployment Script
echo ========================================
echo.

REM AWS credentials check
echo ℹ️  Checking AWS credentials...
aws sts get-caller-identity >nul 2>&1
if errorlevel 1 (
    echo ❌ AWS credentials not found!
    echo Please do one of the following:
    echo 1. Run 'aws configure' command
    echo 2. Set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables
    echo 3. Install AWS CLI: https://aws.amazon.com/cli/
    pause
    exit /b 1
)
echo ✅ AWS credentials verified

REM Terraform check
echo ℹ️  Checking Terraform...
terraform version >nul 2>&1
if errorlevel 1 (
    echo ❌ Terraform not found!
    echo Please install Terraform: https://terraform.io/downloads
    pause
    exit /b 1
)
echo ✅ Terraform found

REM Change to Terraform directory
if not exist "terraform-static-website" (
    echo ❌ terraform-static-website directory not found!
    pause
    exit /b 1
)

cd terraform-static-website
echo ℹ️  Changed to Terraform directory: %CD%

REM Terraform init
echo ℹ️  Initializing Terraform...
if not exist ".terraform" (
    terraform init
    echo ✅ Terraform initialized
) else (
    echo ℹ️  Terraform already initialized
)

REM Terraform plan
echo ℹ️  Creating Terraform plan...
terraform plan -out=tfplan
echo ✅ Terraform plan created

echo.
echo ⚠️  Do you want to continue? (y/N)
set /p response=
if /i "%response%"=="y" (
    REM Terraform apply
    echo ℹ️  Applying Terraform...
    if exist "tfplan" (
        terraform apply tfplan
    ) else (
        terraform apply
    )
    echo ✅ Terraform applied successfully!
    
    REM Show outputs
    echo.
    echo ℹ️  Infrastructure outputs:
    echo.
    echo 🌐 S3 Website Endpoint:
    terraform output s3_website_endpoint
    echo.
    echo ☁️  CloudFront Domain:
    terraform output cloudfront_domain_name
    echo.
    echo 🔗 Route53 Zone Name:
    terraform output route53_zone_name
    echo.
    echo 📡 Route53 Nameservers (for Domain Registrar):
    terraform output route53_nameservers
    echo.
    echo 🆔 CloudFront Distribution ID (for GitHub Secrets):
    terraform output cloudfront_distribution_id
    
    REM Domain registrar instructions
    echo.
    echo ⚠️  DOMAIN REGISTRAR CONFIGURATION REQUIRED!
    echo ================================================
    echo.
    echo To point your ismailkilicaslan.de domain to AWS Route53:
    echo.
    echo 1. Copy the Route53 nameservers above
    echo 2. Go to your domain registrar's DNS management panel
    echo 3. Replace nameservers with the values above
    echo 4. Changes can take 24-48 hours to propagate
    echo.
    echo Required secrets for GitHub Actions:
    echo - AWS_ACCESS_KEY_ID
    echo - AWS_SECRET_ACCESS_KEY
    echo - CLOUDFRONT_DISTRIBUTION_ID (get from output above)
    echo.
    echo See AWS_IAM_SETUP.md file for detailed setup.
) else (
    echo ℹ️  Deployment cancelled
)

pause 