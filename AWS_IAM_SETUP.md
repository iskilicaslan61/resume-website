# AWS IAM Setup Guide for GitHub Actions Deployment

Bu rehber, GitHub Actions'ın AWS'ye dağıtım yapabilmesi için gerekli IAM kullanıcısını ve politikalarını oluşturmayı açıklar.

## 🎯 Hedef

GitHub Actions workflow'unuzun şu işlemleri yapabilmesi için gerekli izinleri sağlamak:
- S3 bucket'a dosya yükleme
- CloudFront cache invalidation
- Sadece gerekli minimum izinler

## 📋 Adım Adım Kurulum

### 1. AWS IAM Kullanıcısı Oluşturma

1. **AWS Console'a giriş yapın** ve IAM servisine gidin
2. **"Users"** sekmesine tıklayın
3. **"Create user"** butonuna tıklayın
4. **Kullanıcı adını girin:** `github-actions-deploy`
5. **"Programmatic access"** seçeneğini işaretleyin
6. **"Next: Permissions"** butonuna tıklayın

### 2. IAM Policy Oluşturma

1. **"Attach policies directly"** seçeneğini seçin
2. **"Create policy"** butonuna tıklayın
3. **JSON** sekmesine tıklayın
4. **Aşağıdaki policy'yi yapıştırın:**

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

5. **"Next: Tags"** butonuna tıklayın (opsiyonel)
6. **"Next: Review"** butonuna tıklayın
7. **Policy adını girin:** `GitHubActionsDeployPolicy`
8. **"Create policy"** butonuna tıklayın

### 3. Policy'yi Kullanıcıya Ekleme

1. **Oluşturduğunuz kullanıcıya geri dönün**
2. **"Attach policies directly"** seçeneğini seçin
3. **Arama kutusuna** `GitHubActionsDeployPolicy` yazın
4. **Policy'yi seçin** ve **"Next: Review"** butonuna tıklayın
5. **"Create user"** butonuna tıklayın

### 4. Access Keys Oluşturma

1. **Oluşturulan kullanıcıya tıklayın**
2. **"Security credentials"** sekmesine tıklayın
3. **"Create access key"** butonuna tıklayın
4. **"Application running outside AWS"** seçeneğini seçin
5. **"Next"** butonuna tıklayın
6. **"Create access key"** butonuna tıklayın
7. **Access Key ID ve Secret Access Key'i kaydedin**

> ⚠️ **ÖNEMLİ:** Secret Access Key'i sadece bir kez gösterilir. Güvenli bir yere kaydedin!

## 🔐 GitHub Secrets Kurulumu

### 1. GitHub Repository'ye Gidin

1. **Repository'nize gidin:** https://github.com/iskilicaslan61/resume-website
2. **"Settings"** sekmesine tıklayın
3. **Sol menüden "Secrets and variables"** → **"Actions"** seçin

### 2. Secrets Ekleme

Aşağıdaki 3 secret'ı ekleyin:

#### AWS_ACCESS_KEY_ID
- **Name:** `AWS_ACCESS_KEY_ID`
- **Value:** IAM kullanıcısından aldığınız Access Key ID

#### AWS_SECRET_ACCESS_KEY
- **Name:** `AWS_SECRET_ACCESS_KEY`
- **Value:** IAM kullanıcısından aldığınız Secret Access Key

#### CLOUDFRONT_DISTRIBUTION_ID
- **Name:** `CLOUDFRONT_DISTRIBUTION_ID`
- **Value:** CloudFront distribution ID (Terraform çıktısından alınacak)

### 3. CloudFront Distribution ID'yi Alma

Terraform'u çalıştırdıktan sonra:

```bash
cd terraform-static-website
terraform output cloudfront_distribution_id
```

Bu komutun çıktısını `CLOUDFRONT_DISTRIBUTION_ID` secret'ına ekleyin.

## 🔍 Test Etme

### 1. Test Commit'i Yapın

```bash
# Repository'nizi klonlayın (eğer henüz yapmadıysanız)
git clone https://github.com/iskilicaslan61/resume-website.git
cd resume-website

# Küçük bir değişiklik yapın
echo "# Test" >> README.md

# Commit ve push yapın
git add README.md
git commit -m "Test deployment"
git push origin main
```

### 2. GitHub Actions'ı İzleyin

1. **Repository'nizde "Actions"** sekmesine gidin
2. **Workflow'un çalışmasını bekleyin**
3. **Başarılı olup olmadığını kontrol edin**

## 🛡️ Güvenlik En İyi Uygulamaları

### 1. Minimum İzin Prensibi
- Kullanıcı sadece gerekli minimum izinlere sahip
- Sadece belirli S3 bucket'a erişim
- Sadece CloudFront invalidation izni

### 2. Düzenli Key Rotasyonu
- Access key'leri düzenli olarak değiştirin (3-6 ayda bir)
- Eski key'leri hemen silin

### 3. Monitoring
- CloudTrail ile API çağrılarını izleyin
- Anormal aktiviteleri kontrol edin

## 🆘 Sorun Giderme

### "Access Denied" Hatası
- IAM policy'nin doğru eklendiğinden emin olun
- S3 bucket adının doğru olduğunu kontrol edin
- CloudFront distribution ID'nin doğru olduğunu kontrol edin

### "Invalid credentials" Hatası
- Access key'lerin doğru kopyalandığını kontrol edin
- GitHub secrets'ın doğru adlandırıldığını kontrol edin

### "Distribution not found" Hatası
- CloudFront distribution ID'nin güncel olduğunu kontrol edin
- Terraform'u yeniden çalıştırıp yeni ID'yi alın

## 📚 Ek Kaynaklar

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [AWS S3 Permissions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-with-s3-actions.html)
- [CloudFront Invalidation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html) 