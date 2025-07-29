# 🟦 Terraform Static Website on AWS - ismailkilicaslan.de

This module provides a fully automated, modular, and production-ready Infrastructure as Code (IaC) solution for the `ismailkilicaslan.de` domain. It provides static website hosting using S3, CloudFront, Route53, and ACM, all managed with Terraform.

**🌐 Domain:** ismailkilicaslan.de  
**📦 Repository:** https://github.com/iskilicaslan61/resume-website

---

## 🚀 Step by Step: Deploy Your Static Website on AWS

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/iskilicaslan61/resume-website.git
cd resume-website/terraform-static-website
```

### **Step 2: Configure Your Variables**
- Edit the `variables.tf` file:
  - `aws_region`: AWS region (default: `us-east-1`)
  - `domain_name`: Your main domain (`ismailkilicaslan.de`)
  - `aliases`: List of all domains/subdomains

### **Step 3: Initialize Terraform**
```bash
terraform init
```

### **Step 4: Review the Plan**
```bash
terraform plan
```
- Shows which resources will be created or modified.

### **Step 5: Apply Infrastructure**
```bash
terraform apply --auto-approve
```

### **Step 6: Update Your Domain Registrar**
- Go to your domain registrar's panel
- Replace existing NS (Name Server) records with the four NS records from the Route53 hosted zone
- **Important:** DNS propagation can take 5-30 minutes

### **Step 7: Check Outputs**
- After apply, Terraform outputs:
  - S3 website endpoint
  - CloudFront distribution domain
  - Route53 hosted zone name
  - **Route53 nameservers** (for domain registrar)
  - **CloudFront distribution ID** (for GitHub Actions)

### **Step 8: Upload Your Website**
- Use AWS Console or CLI to upload your static website files to the S3 bucket
- Example:
  ```bash
  aws s3 sync ../ s3://ismailkilicaslan.de --delete
  ```

### **Step 9: Test Your Website**
- Open your domain in your browser (`https://ismailkilicaslan.de`)
- Verify HTTPS is working and your site loads correctly

---

## 🚀 What This Module Does
- **Creates S3 bucket** for static website hosting
- **Sets up CloudFront** for global CDN, HTTPS, and custom domains
- **Manages Route53 DNS** (hosted zone, A records, validation records)
- **Uses existing ACM SSL certificate** (wildcard, automatic DNS validation)
- **Outputs all important endpoints** for easy integration
- **Provides full automation and CI/CD support** (see main project README)

---

## 🗂️ File and Module Structure

- `main.tf` – Providers (AWS, regions) and entry point
- `variables.tf` – All variables (region, domain, aliases)
- `s3.tf` – S3 bucket, public access, and policy
- `cert.tf` – Using existing ACM wildcard certificate
- `route53.tf` – Hosted zone, DNS records
- `cloudfront.tf` – CloudFront distribution (CDN, HTTPS, aliases)
- `outputs.tf` – Outputs for endpoints and zone names

---

## 🧩 Adding New Subdomains
1. Edit the `variables.tf` file and add your new subdomain to the `aliases` list:
   ```hcl
   variable "aliases" {
     default = [
       "ismailkilicaslan.de",
       "www.ismailkilicaslan.de",
       "blog.ismailkilicaslan.de" # <--- Add here
     ]
   }
   ```
2. Run:
   ```bash
   terraform apply
   ```
3. That's it! All DNS and CloudFront settings are automatically updated.

---

## 🛡️ Best Practices and Notes
- **Never manually edit AWS Console resources managed by Terraform**
- **All DNS records** (A, CNAME, etc.) should be managed by this module
- **ACM certificates for CloudFront** must be created in `us-east-1`
- **S3 bucket names** must be globally unique
- **Use version control** for your `.tf` files and keep your state files secure
- **Delete manual Route53 records before applying** to prevent conflicts
- **Force destroy** is enabled for S3 bucket (easy cleanup for dev/test)

---

## 🆘 Troubleshooting and FAQ
- **Terraform apply gives "already exists" error**: There might be manual records or resources in AWS. Delete them or import to Terraform
- **ACM validation stuck**: Check that Route53 CNAME validation records exist and are correct
- **CloudFront not serving HTTPS**: Certificate must be in `us-east-1` and fully validated
- **S3 access denied**: Check bucket policy and public access block settings
- **DNS not resolving**: Make sure your domain's NS records in registrar match the Route53 hosted zone

---

## 📚 Resources
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)

---

## 💡 Additional Tips
- This module is designed for learning, prototyping, and production use
- Easily extensible for multi-environment (dev/stage/prod) setups using workspaces or variable overrides
- Consider using CloudFront Origin Access Control (OAC) or OAI for private/static sites
- Always review AWS costs before deploying to production
- Pull requests and suggestions are welcome!

---

## 🗑️ Removing Resources from Terraform State (State Management)

If you need to remove a resource from Terraform state (e.g., after manually deleting it in AWS), follow these steps:

### 1. List All Resources in State
Run:
```bash
terraform state list
```
This command shows all resources tracked in your state file.

### 2. Find the Correct Resource Address
Look for a line like:
```
aws_route53_record.cert_validation["your-key"]
```
or
```
aws_route53_record.cert_validation
```

### 3. Copy the Full Address
Copy the exact line as shown in the output.

### 4. Remove Resource from State
Run:
```bash
terraform state rm 'paste-full-address-here'
```
**Example:**
```bash
terraform state rm 'aws_route53_record.cert_validation["your-key"]'
```

### 5. If You Can't Find the Resource
If the resource is not listed in state, you don't need to remove it.
You can safely continue:
```bash
terraform apply
```

---

## 📝 License
MIT

---

## 👤 Author
İsmail Kılıçaslan

---

## 🎯 Current Configuration

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

### **Required GitHub Actions Secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFRONT_DISTRIBUTION_ID` = `E1AU95JGWIP80S`