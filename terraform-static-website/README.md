# 🟦 Terraform Static Website on AWS - ismailkilicaslan.de

Bu modül, `ismailkilicaslan.de` domain'i için tamamen otomatikleştirilmiş, modüler ve production-ready Infrastructure as Code (IaC) çözümü sağlar. S3, CloudFront, Route53 ve ACM kullanarak statik web sitesi hosting'i yapar ve Terraform ile yönetilir.

**🌐 Domain:** ismailkilicaslan.de  
**📦 Repository:** https://github.com/iskilicaslan61/resume-website

---

## 🚀 Adım Adım: AWS'de Statik Web Sitenizi Dağıtın

### **Adım 1: Repository'yi Klonlayın**
```bash
git clone https://github.com/iskilicaslan61/resume-website.git
cd resume-website/terraform-static-website
```

### **Adım 2: Değişkenlerinizi Yapılandırın**
- `variables.tf` dosyasını düzenleyin:
  - `aws_region`: AWS bölgesi (varsayılan: `us-east-1`)
  - `domain_name`: Ana domain'iniz (`ismailkilicaslan.de`)
  - `aliases`: Tüm domain/subdomain'lerin listesi

### **Adım 3: Terraform'u Başlatın**
```bash
terraform init
```

### **Adım 4: Planı Gözden Geçirin**
```bash
terraform plan
```
- Hangi kaynakların oluşturulacağını veya değiştirileceğini gösterir.

### **Adım 5: Infrastructure'ı Uygulayın**
```bash
terraform apply --auto-approve
```

### **Adım 6: Domain Registrar'ınızı Güncelleyin**
- Domain registrar'ınızın paneline gidin
- Mevcut NS (Name Server) kayıtlarını Route53 hosted zone'dan aldığınız dört NS kaydıyla değiştirin
- **Önemli:** DNS yayılması 5-30 dakika sürebilir

### **Adım 7: Çıktıları Kontrol Edin**
- Apply sonrası Terraform şunları çıktı olarak verir:
  - S3 website endpoint
  - CloudFront distribution domain
  - Route53 hosted zone name
  - **Route53 nameservers** (domain registrar için)
  - **CloudFront distribution ID** (GitHub Actions için)

### **Adım 8: Web Sitenizi Yükleyin**
- AWS Console veya CLI kullanarak statik web sitesi dosyalarınızı S3 bucket'a yükleyin
- Örnek:
  ```bash
  aws s3 sync ../ s3://ismailkilicaslan.de --delete
  ```

### **Adım 9: Web Sitenizi Test Edin**
- Tarayıcınızda domain'inizi açın (`https://ismailkilicaslan.de`)
- HTTPS'in çalıştığını ve sitenizin doğru yüklendiğini kontrol edin

---

## 🚀 Bu Modül Ne Yapar?
- **S3 bucket oluşturur** statik web sitesi hosting için
- **CloudFront kurar** global CDN, HTTPS ve özel domain'ler için
- **Route53 DNS'i yönetir** (hosted zone, A kayıtları, validation kayıtları)
- **Mevcut ACM SSL sertifikasını kullanır** (wildcard, otomatik DNS validation)
- **Tüm önemli endpoint'leri çıktı olarak verir** kolay entegrasyon için
- **Tam otomasyon ve CI/CD desteği** sağlar (ana proje README'ye bakın)

---

## 🗂️ Dosya ve Modül Yapısı

- `main.tf` – Provider'lar (AWS, bölgeler) ve giriş noktası
- `variables.tf` – Tüm değişkenler (bölge, domain, alias'lar)
- `s3.tf` – S3 bucket, public access ve policy
- `cert.tf` – Mevcut ACM wildcard sertifikası kullanımı
- `route53.tf` – Hosted zone, DNS kayıtları
- `cloudfront.tf` – CloudFront distribution (CDN, HTTPS, alias'lar)
- `outputs.tf` – Endpoint'ler ve zone isimleri için çıktılar

---

## 🧩 Yeni Subdomain Ekleme
1. `variables.tf` dosyasını düzenleyin ve yeni subdomain'inizi `aliases` listesine ekleyin:
   ```hcl
   variable "aliases" {
     default = [
       "ismailkilicaslan.de",
       "www.ismailkilicaslan.de",
       "blog.ismailkilicaslan.de" # <--- Buraya ekleyin
     ]
   }
   ```
2. Çalıştırın:
   ```bash
   terraform apply
   ```
3. Bu kadar! Tüm DNS ve CloudFront ayarları otomatik olarak güncellenir.

---

## 🛡️ En İyi Uygulamalar ve Notlar
- **Terraform tarafından yönetilen AWS Console kaynaklarını asla manuel olarak düzenlemeyin**
- **Tüm DNS kayıtları** (A, CNAME, vb.) bu modül tarafından yönetilmelidir
- **CloudFront için ACM sertifikaları** `us-east-1`'de oluşturulmalıdır
- **S3 bucket isimleri** global olarak benzersiz olmalıdır
- **Version control kullanın** `.tf` dosyalarınız için ve state dosyalarınızı güvende tutun
- **Uygulamadan önce manuel Route53 kayıtlarını silin** çakışmaları önlemek için
- **Force destroy** S3 bucket için etkinleştirilmiştir (dev/test için kolay temizlik)

---

## 🆘 Sorun Giderme ve SSS
- **Terraform apply "already exists" hatası veriyor**: AWS'de manuel kayıt veya kaynak olabilir. Silin veya Terraform'a import edin
- **ACM validation takıldı**: Route53 CNAME validation kayıtlarının var olduğunu ve doğru olduğunu kontrol edin
- **CloudFront HTTPS sunmuyor**: Sertifika `us-east-1`'de olmalı ve tamamen doğrulanmış olmalı
- **S3 erişim reddedildi**: Bucket policy ve public access block ayarlarını kontrol edin
- **DNS çözümlenmiyor**: Domain'inizin registrar'daki NS kayıtlarının Route53 hosted zone ile eşleştiğinden emin olun

---

## 📚 Kaynaklar
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)

---

## 💡 Ek İpuçları
- Bu modül öğrenme, prototipleme ve production kullanımı için tasarlanmıştır
- Workspace'ler veya değişken override'ları kullanarak multi-environment (dev/stage/prod) kurulumları için kolayca genişletilebilir
- Özel/statik siteler için CloudFront Origin Access Control (OAC) veya OAI kullanmayı düşünün
- Production'da dağıtmadan önce AWS maliyetlerini her zaman gözden geçirin
- Pull request'ler ve öneriler hoş karşılanır!

---

## 🗑️ Terraform State'den Kaynak Kaldırma (State Yönetimi)

Eğer bir kaynağı Terraform state'den kaldırmanız gerekiyorsa (örneğin, AWS'de manuel olarak sildikten sonra), şu adımları izleyin:

### 1. State'deki Tüm Kaynakları Listele
Çalıştırın:
```bash
terraform state list
```
Bu komut state dosyanızda takip edilen tüm kaynakları gösterir.

### 2. Doğru Kaynak Adresini Bulun
Şuna benzer bir satır arayın:
```
aws_route53_record.cert_validation["your-key"]
```
veya
```
aws_route53_record.cert_validation
```

### 3. Tam Adresi Kopyalayın
Çıktıda gösterildiği gibi tam satırı kopyalayın.

### 4. Kaynağı State'den Kaldırın
Çalıştırın:
```bash
terraform state rm 'tam-adresi-buraya-yapıştırın'
```
**Örnek:**
```bash
terraform state rm 'aws_route53_record.cert_validation["your-key"]'
```

### 5. Kaynağı Bulamıyorsanız
Eğer kaynak state'de listelenmemişse, kaldırmanıza gerek yoktur.
Güvenle devam edebilirsiniz:
```bash
terraform apply
```

---

## 📝 Lisans
MIT

---

## 👤 Yazar
İsmail Kılıçaslan

---

## 🎯 Mevcut Konfigürasyon

### **Domain:** ismailkilicaslan.de
### **S3 Bucket:** ismailkilicaslan.de
### **CloudFront Distribution ID:** E1AU95JGWIP80S
### **Route53 Zone ID:** Z099757327K2VT312NQLU

### **Route53 Nameservers:**
```
ns-1155.awsdns-16.org
ns-1741.awsdns-25.co.uk
ns-356.awsdns-44.com
ns-785.awsdns-34.net
```

### **GitHub Actions için Gerekli Secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFRONT_DISTRIBUTION_ID` = `E1AU95JGWIP80S`