# 🚀 Hızlı Kurulum Rehberi - ismailkilicaslan.de

Bu rehber, `ismailkilicaslan.de` domain'iniz için AWS infrastructure'ını hızlıca kurmanızı sağlar.

## 📋 Ön Gereksinimler

- [ ] AWS hesabı
- [ ] `ismailkilicaslan.de` domain'i
- [ ] Terraform yüklü
- [ ] AWS CLI yüklü ve yapılandırılmış

## 🔧 Adım 1: Infrastructure'ı Dağıtın

### Windows için:
```cmd
deploy.bat
```

### Linux/Mac için:
```bash
./deploy.sh
```

### Manuel olarak:
```bash
cd terraform-static-website
terraform init
terraform plan
terraform apply
```

## 🌐 Adım 2: Domain Registrar'ı Yapılandırın

1. **Terraform çıktısından nameserver'ları alın:**
   ```bash
   terraform output route53_nameservers
   ```

2. **Domain registrar'ınızda nameserver'ları güncelleyin:**
   - Domain registrar'ınızın DNS yönetim paneline gidin
   - Nameserver'ları Terraform'dan aldığınız değerlerle değiştirin
   - Değişikliklerin yayılması 24-48 saat sürebilir

## 🔐 Adım 3: GitHub Actions Kurulumu

### 3.1 AWS IAM Kullanıcısı Oluşturun

1. **AWS Console'da IAM servisine gidin**
2. **Yeni bir kullanıcı oluşturun:** `github-actions-deploy`
3. **Programmatic access** seçin
4. **Aşağıdaki policy'yi ekleyin:**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::ismailkilicaslan.de",
                "arn:aws:s3:::ismailkilicaslan.de/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation",
                "cloudfront:GetInvalidation",
                "cloudfront:ListInvalidations"
            ],
            "Resource": "*"
        }
    ]
}
```

5. **Access Key ID ve Secret Access Key'i kaydedin**

### 3.2 GitHub Secrets Ekleme

1. **Repository'nize gidin:** https://github.com/iskilicaslan61/resume-website
2. **Settings** → **Secrets and variables** → **Actions**
3. **Aşağıdaki secrets'ları ekleyin:**

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | IAM kullanıcısının Access Key ID'si |
| `AWS_SECRET_ACCESS_KEY` | IAM kullanıcısının Secret Access Key'i |
| `CLOUDFRONT_DISTRIBUTION_ID` | Terraform çıktısından alınan Distribution ID |

## 🎯 Adım 4: Test Edin

1. **Repository'de küçük bir değişiklik yapın**
2. **Commit ve push yapın**
3. **GitHub Actions'da workflow'un çalışmasını izleyin**
4. **https://ismailkilicaslan.de adresini ziyaret edin**

## 📁 Proje Yapısı

```
resume-website/
├── index.html              # Ana sayfa
├── css/styles.css          # Stiller
├── js/scripts.js           # JavaScript
├── assets/                 # Resimler ve ikonlar
├── src/                    # HTML bölümleri
├── terraform-static-website/ # AWS infrastructure
├── .github/workflows/      # GitHub Actions
├── deploy.bat              # Windows deployment script
├── deploy.sh               # Linux/Mac deployment script
└── README.md               # Detaylı dokümantasyon
```

## 🔧 Web Sitesini Düzenleme

- **Ana sayfa:** `index.html`
- **Stiller:** `css/styles.css`
- **JavaScript:** `js/scripts.js`
- **Resimler:** `assets/images/`
- **Bölümler:** `src/` dizinindeki HTML dosyaları

## 🆘 Sorun Giderme

### DNS çalışmıyor
- Nameserver'ların doğru ayarlandığını kontrol edin
- 24-48 saat bekleyin

### GitHub Actions başarısız
- AWS credentials'ları kontrol edin
- CloudFront Distribution ID'nin doğru olduğunu kontrol edin

### SSL hatası
- ACM sertifikasının doğrulandığını kontrol edin
- CloudFront distribution'ın aktif olduğunu kontrol edin

## 📞 Destek

Sorun yaşarsanız:
1. GitHub Actions loglarını kontrol edin
2. AWS CloudTrail'de hataları arayın
3. Terraform state'ini kontrol edin

## 🎉 Başarı!

Artık `ismailkilicaslan.de` adresinde profesyonel CV web siteniz yayında! Her değişiklik GitHub'a push ettiğinizde otomatik olarak güncellenecek. 