# CV Website – Automated Static Site on AWS with Terraform & GitHub Actions

Bu proje, AWS'de tamamen otomatikleştirilmiş, profesyonel bir CV (özgeçmiş) web sitesidir. Infrastructure as Code (IaC) ile Terraform ve GitHub Actions ile sürekli dağıtım kullanır. Site global olarak erişilebilir, güvenli (HTTPS) ve güncellemesi kolaydır—sadece GitHub'a push yapın!

**🌐 Website:** https://ismailkilicaslan.de  
**📦 GitHub Repository:** https://github.com/iskilicaslan61/resume-website

---

## 🚀 Özellikler

* **Modern, responsive CV website** (HTML, CSS, JS, images, assets)
* **AWS S3** for static website hosting
* **AWS CloudFront** for CDN, HTTPS, and custom domains
* **AWS Route53** for DNS management
* **AWS ACM** for free SSL certificates (wildcard support)
* **Terraform** for modular, repeatable infrastructure
* **GitHub Actions** for automatic deployment (CI/CD)
* **Best practices** for security, automation, and maintainability

---

## 🗂️ Proje Yapısı

```
resume-website/
├── assets/                # Images, icons, fonts
├── css/                   # Stylesheets
├── js/                    # JavaScript files
├── src/                   # HTML sections (for modular editing)
│   ├── home.html
│   ├── berufserfahrungen.html
│   ├── kompetenzen.html
│   ├── projekte.html
│   ├── bildungs.html
│   └── kontakt.html
├── index.html             # Main entry point
├── error.html             # Custom error page (for 404/403)
├── terraform-static-website/ # All Terraform IaC code
│   ├── main.tf
│   ├── variables.tf
│   ├── s3.tf
│   ├── cert.tf
│   ├── route53.tf
│   ├── cloudfront.tf
│   ├── outputs.tf
│   └── README.md
├── .github/workflows/deploy.yml # GitHub Actions CI/CD pipeline
├── .gitignore             # Ignore Terraform state, cache, temp, etc.
├── AWS_IAM_SETUP.md       # Guide for AWS IAM user & GitHub secrets
└── README.md              # This file
```

---

## 🛠️ Yerel Geliştirme

1. **Repository'yi klonlayın:**  
   ```bash
   git clone https://github.com/iskilicaslan61/resume-website.git
   cd resume-website
   ```

2. **Web sitenizi düzenleyin:**  
   * Ana dosya: `index.html`  
   * Stiller: `css/styles.css`  
   * JavaScript: `js/scripts.js`  
   * Resimler: `assets/images/`  
   * Modüler HTML: `src/`

3. **Yerel olarak önizleyin:**  
   * VS Code Live Server kullanın veya `python3 -m http.server` ile önizleyin.

---

## ☁️ Infrastructure as Code (Terraform)

Tüm AWS kaynakları, tam yeniden üretilebilirlik ve otomasyon için Terraform ile yönetilir.

### **Otomatikleştirilen Öğeler:**

* S3 bucket for static hosting
* CloudFront distribution (CDN, HTTPS)
* Route53 hosted zone and DNS records
* ACM SSL certificate (wildcard, auto-validation)

### **Infrastructure'ı Dağıtma:**

1. **Terraform'u yükleyin:** https://terraform.io/downloads
2. **AWS credentials'ları yapılandırın** (`aws configure` veya environment variables ile)
3. **Değişkenleri düzenleyin:**  
   * `terraform-static-website/variables.tf` (domain, region, vb. ayarlayın)
4. **Terraform'u başlatın:**  
   ```bash
   cd terraform-static-website
   terraform init
   ```
5. **Planı gözden geçirin:**  
   ```bash
   terraform plan
   ```
6. **Infrastructure'ı uygulayın:**  
   ```bash
   terraform apply
   ```
7. **Çıktıları kontrol edin:**  
   * S3 website endpoint  
   * CloudFront domain  
   * Route53 zone name
   * **Route53 nameservers** (domain registrar için gerekli)

> **Önemli Notlar:**
> 
> * Tüm DNS kayıtları Terraform tarafından yönetilmelidir. Uygulamadan önce Route53'teki manuel kayıtları silin.
> * CloudFront için ACM sertifikaları `us-east-1`'de oluşturulmalıdır.
> * S3 bucket isimleri global olarak benzersiz olmalıdır.

---

## 🔐 AWS IAM & GitHub Secrets Kurulumu

GitHub Actions'ın AWS'ye dağıtım yapabilmesi için, sınırlı izinlere sahip bir IAM kullanıcısına ve credentials'larını GitHub secrets olarak saklamaya ihtiyacınız var.

Detaylı adım adım rehber için `AWS_IAM_SETUP.md` dosyasına bakın.

**Gerekli GitHub secrets:**

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `CLOUDFRONT_DISTRIBUTION_ID`

---

## 🌐 Domain Registrar Yapılandırması

`ismailkilicaslan.de` domain'inizi AWS Route53'e yönlendirmek için:

1. **Terraform çıktısından nameserver'ları alın:**
   ```bash
   terraform output route53_nameservers
   ```

2. **Domain registrar'ınızda nameserver'ları güncelleyin:**
   * Domain registrar'ınızın DNS yönetim paneline gidin
   * Nameserver'ları Terraform'dan aldığınız değerlerle değiştirin
   * Değişikliklerin yayılması 24-48 saat sürebilir

---

## 🤖 CI/CD: GitHub Actions ile Otomatik Dağıtım

`main` branch'e her push, şu işlemleri yapan bir workflow'u tetikler:

1. Website dosyalarından oluşan bir deployment dizini oluşturur
2. Dosyaları S3'e senkronize eder (silinen dosyaları kaldırır)
3. CloudFront cache'ini geçersiz kılar (değişiklikler hemen canlı olur)

**Workflow dosyası:** `.github/workflows/deploy.yml`

**Nasıl çalışır:**

* Sadece web dosyaları dağıtılır (Terraform, .git, temp dosyaları, vb. göz ardı edilir)
* Güvenli: AWS credentials'ları asla kodda saklanmaz, sadece GitHub secrets olarak
* Hızlı: Sadece değişen dosyalar yüklenir

---

## 📝 En İyi Uygulamalar & İpuçları

* **AWS credentials'larını veya Terraform state'ini asla git'e commit etmeyin**
* **.gitignore kullanın** repository'nizi temiz tutmak için
* **Tüm infrastructure kod olarak**: AWS Console'da manuel değişiklik yapmayın
* **Modüler Terraform dosyaları kullanın** netlik ve yeniden kullanılabilirlik için
* **Push etmeden önce yerel olarak test edin**
* **Dağıtım durumu için GitHub Actions loglarını izleyin**
* **AWS key'lerini düzenli olarak değiştirin**

---

## 🧩 Özelleştirme

* **Domain'inizi değiştirin:** `variables.tf`'yi düzenleyin ve Route53/CloudFront ayarlarını güncelleyin
* **Subdomain'ler ekleyin:** `cloudfront.tf` ve `route53.tf`'yi güncelleyin
* **Region'ı değiştirin:** `variables.tf`'yi düzenleyin
* **Yeni bölümler ekleyin:** `src/`'de yeni HTML dosyaları oluşturun ve `index.html`'de bağlayın
* **Tasarımı değiştirin:** `css/styles.css` ve assets'leri düzenleyin

---

## 🆘 Sorun Giderme

* **DNS çalışmıyor mu?** Domain registrar'ınızdaki NS kayıtlarını ve Route53'i kontrol edin
* **SSL hatası mı?** ACM sertifikasının doğrulandığından ve `us-east-1`'de olduğundan emin olun
* **S3 erişim reddedildi mi?** Bucket policy ve public access ayarlarını kontrol edin
* **GitHub Actions başarısız mı oldu?** Actions sekmesindeki logları kontrol edin
* **CloudFront güncellenmiyor mu?** Invalidation birkaç dakika sürebilir

---

## 📚 Kaynaklar

* [Terraform Documentation](https://www.terraform.io/docs)
* [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
* [AWS CloudFront](https://docs.aws.amazon.com/cloudfront/)
* [AWS Route53](https://docs.aws.amazon.com/route53/)
* [GitHub Actions](https://docs.github.com/en/actions)

---

## 📝 Lisans

MIT

---

## 👤 Yazar

İsmail Kılıçaslan

---

## 💡 Katkıda Bulunma

Pull request'ler hoş karşılanır! Büyük değişiklikler için lütfen önce neyi değiştirmek istediğinizi tartışmak için bir issue açın.

