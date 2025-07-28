#!/bin/bash

# Resume Website AWS Deployment Script
# Bu script, Terraform ile AWS infrastructure'ını dağıtır

set -e  # Hata durumunda script'i durdur

echo "🚀 Resume Website AWS Deployment Script"
echo "========================================"
echo ""

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonksiyonlar
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

# AWS credentials kontrolü
check_aws_credentials() {
    print_info "AWS credentials kontrol ediliyor..."
    
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials bulunamadı!"
        echo "Lütfen aşağıdakilerden birini yapın:"
        echo "1. 'aws configure' komutunu çalıştırın"
        echo "2. AWS_ACCESS_KEY_ID ve AWS_SECRET_ACCESS_KEY environment variables'larını ayarlayın"
        echo "3. AWS CLI'yi yükleyin: https://aws.amazon.com/cli/"
        exit 1
    fi
    
    print_success "AWS credentials doğrulandı"
}

# Terraform kontrolü
check_terraform() {
    print_info "Terraform kontrol ediliyor..."
    
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform bulunamadı!"
        echo "Lütfen Terraform'u yükleyin: https://terraform.io/downloads"
        exit 1
    fi
    
    print_success "Terraform bulundu: $(terraform version | head -n1)"
}

# Terraform dizinine geç
cd_terraform_dir() {
    if [ ! -d "terraform-static-website" ]; then
        print_error "terraform-static-website dizini bulunamadı!"
        exit 1
    fi
    
    cd terraform-static-website
    print_info "Terraform dizinine geçildi: $(pwd)"
}

# Terraform init
terraform_init() {
    print_info "Terraform başlatılıyor..."
    
    if [ ! -d ".terraform" ]; then
        terraform init
        print_success "Terraform başlatıldı"
    else
        print_info "Terraform zaten başlatılmış"
    fi
}

# Terraform plan
terraform_plan() {
    print_info "Terraform plan oluşturuluyor..."
    
    terraform plan -out=tfplan
    print_success "Terraform plan oluşturuldu"
}

# Terraform apply
terraform_apply() {
    print_info "Terraform uygulanıyor..."
    
    if [ -f "tfplan" ]; then
        terraform apply tfplan
    else
        terraform apply
    fi
    
    print_success "Terraform başarıyla uygulandı!"
}

# Çıktıları göster
show_outputs() {
    print_info "Infrastructure çıktıları:"
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
    echo "📡 Route53 Nameservers (Domain Registrar için):"
    terraform output route53_nameservers
    
    echo ""
    echo "🆔 CloudFront Distribution ID (GitHub Secrets için):"
    terraform output cloudfront_distribution_id
}

# Domain registrar talimatları
show_domain_instructions() {
    echo ""
    print_warning "DOMAIN REGISTRAR YAPILANDIRMASI GEREKLİ!"
    echo "================================================"
    echo ""
    echo "ismailkilicaslan.de domain'inizi AWS Route53'e yönlendirmek için:"
    echo ""
    echo "1. Yukarıdaki Route53 nameserver'larını kopyalayın"
    echo "2. Domain registrar'ınızın DNS yönetim paneline gidin"
    echo "3. Nameserver'ları yukarıdaki değerlerle değiştirin"
    echo "4. Değişikliklerin yayılması 24-48 saat sürebilir"
    echo ""
    echo "GitHub Actions için gerekli secrets:"
    echo "- AWS_ACCESS_KEY_ID"
    echo "- AWS_SECRET_ACCESS_KEY"
    echo "- CLOUDFRONT_DISTRIBUTION_ID (yukarıdaki çıktıdan alın)"
    echo ""
    echo "Detaylı kurulum için AWS_IAM_SETUP.md dosyasına bakın."
}

# Ana fonksiyon
main() {
    echo ""
    
    # Kontroller
    check_aws_credentials
    check_terraform
    
    # Terraform dizinine geç
    cd_terraform_dir
    
    # Terraform işlemleri
    terraform_init
    terraform_plan
    
    echo ""
    print_warning "Devam etmek istiyor musunuz? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        terraform_apply
        show_outputs
        show_domain_instructions
    else
        print_info "Deployment iptal edildi"
        exit 0
    fi
}

# Script'i çalıştır
main "$@" 