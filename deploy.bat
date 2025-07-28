@echo off
setlocal enabledelayedexpansion

REM Resume Website AWS Deployment Script
REM Bu script, Terraform ile AWS infrastructure'ını dağıtır

echo.
echo 🚀 Resume Website AWS Deployment Script
echo ========================================
echo.

REM AWS credentials kontrolü
echo ℹ️  AWS credentials kontrol ediliyor...
aws sts get-caller-identity >nul 2>&1
if errorlevel 1 (
    echo ❌ AWS credentials bulunamadı!
    echo Lütfen aşağıdakilerden birini yapın:
    echo 1. 'aws configure' komutunu çalıştırın
    echo 2. AWS_ACCESS_KEY_ID ve AWS_SECRET_ACCESS_KEY environment variables'larını ayarlayın
    echo 3. AWS CLI'yi yükleyin: https://aws.amazon.com/cli/
    pause
    exit /b 1
)
echo ✅ AWS credentials doğrulandı

REM Terraform kontrolü
echo ℹ️  Terraform kontrol ediliyor...
terraform version >nul 2>&1
if errorlevel 1 (
    echo ❌ Terraform bulunamadı!
    echo Lütfen Terraform'u yükleyin: https://terraform.io/downloads
    pause
    exit /b 1
)
echo ✅ Terraform bulundu

REM Terraform dizinine geç
if not exist "terraform-static-website" (
    echo ❌ terraform-static-website dizini bulunamadı!
    pause
    exit /b 1
)

cd terraform-static-website
echo ℹ️  Terraform dizinine geçildi: %CD%

REM Terraform init
echo ℹ️  Terraform başlatılıyor...
if not exist ".terraform" (
    terraform init
    echo ✅ Terraform başlatıldı
) else (
    echo ℹ️  Terraform zaten başlatılmış
)

REM Terraform plan
echo ℹ️  Terraform plan oluşturuluyor...
terraform plan -out=tfplan
echo ✅ Terraform plan oluşturuldu

echo.
echo ⚠️  Devam etmek istiyor musunuz? (y/N)
set /p response=
if /i "%response%"=="y" (
    REM Terraform apply
    echo ℹ️  Terraform uygulanıyor...
    if exist "tfplan" (
        terraform apply tfplan
    ) else (
        terraform apply
    )
    echo ✅ Terraform başarıyla uygulandı!
    
    REM Çıktıları göster
    echo.
    echo ℹ️  Infrastructure çıktıları:
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
    echo 📡 Route53 Nameservers (Domain Registrar için):
    terraform output route53_nameservers
    echo.
    echo 🆔 CloudFront Distribution ID (GitHub Secrets için):
    terraform output cloudfront_distribution_id
    
    REM Domain registrar talimatları
    echo.
    echo ⚠️  DOMAIN REGISTRAR YAPILANDIRMASI GEREKLİ!
    echo ================================================
    echo.
    echo ismailkilicaslan.de domain'inizi AWS Route53'e yönlendirmek için:
    echo.
    echo 1. Yukarıdaki Route53 nameserver'larını kopyalayın
    echo 2. Domain registrar'ınızın DNS yönetim paneline gidin
    echo 3. Nameserver'ları yukarıdaki değerlerle değiştirin
    echo 4. Değişikliklerin yayılması 24-48 saat sürebilir
    echo.
    echo GitHub Actions için gerekli secrets:
    echo - AWS_ACCESS_KEY_ID
    echo - AWS_SECRET_ACCESS_KEY
    echo - CLOUDFRONT_DISTRIBUTION_ID (yukarıdaki çıktıdan alın)
    echo.
    echo Detaylı kurulum için AWS_IAM_SETUP.md dosyasına bakın.
) else (
    echo ℹ️  Deployment iptal edildi
)

pause 