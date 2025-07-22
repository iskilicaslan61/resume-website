# CV Website – Automated Static Site on AWS with Terraform & GitHub Actions

This project is a fully automated, professional CV (resume) website hosted on AWS. It uses Infrastructure as Code (IaC) with Terraform and continuous deployment via GitHub Actions. The site is globally available, secure (HTTPS), and easy to update—just push to GitHub!

---

## 🚀 Features
- **Modern, responsive CV website** (HTML, CSS, JS, images, assets)
- **AWS S3** for static website hosting
- **AWS CloudFront** for CDN, HTTPS, and custom domains
- **AWS Route53** for DNS management
- **AWS ACM** for free SSL certificates (wildcard support)
- **Terraform** for modular, repeatable infrastructure
- **GitHub Actions** for automatic deployment (CI/CD)
- **Best practices** for security, automation, and maintainability

---

## 🗂️ Project Structure

```
cv-website/
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

## 🛠️ Local Development

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd cv-website
   ```
2. **Edit your website:**
   - Main file: `index.html`
   - Styles: `css/styles.css`
   - JS: `js/scripts.js`
   - Images: `assets/images/`
   - Modular HTML: `src/`
3. **Preview locally:**
   - Use VS Code Live Server or `python3 -m http.server` to preview.

---

## ☁️ Infrastructure as Code (Terraform)

All AWS resources are managed with Terraform for full reproducibility and automation.

### **What's Automated?**
- S3 bucket for static hosting
- CloudFront distribution (CDN, HTTPS)
- Route53 hosted zone and DNS records
- ACM SSL certificate (wildcard, auto-validation)

### **How to Deploy Infrastructure:**
1. **Install Terraform:** [terraform.io/downloads](https://www.terraform.io/downloads)
2. **Configure AWS credentials** (e.g. with `aws configure` or environment variables)
3. **Edit variables:**
   - `terraform-static-website/variables.tf` (set your domain, region, etc.)
4. **Initialize Terraform:**
   ```sh
   cd terraform-static-website
   terraform init
   ```
5. **Review the plan:**
   ```sh
   terraform plan
   ```
6. **Apply the infrastructure:**
   ```sh
   terraform apply
   ```
7. **Check outputs:**
   - S3 website endpoint
   - CloudFront domain
   - Route53 zone name

> **Note:**
> - All DNS records should be managed by Terraform. Delete any manual records in Route53 before applying.
> - ACM certificates for CloudFront must be created in `us-east-1`.
> - S3 bucket names must be globally unique.

---

## 🔐 AWS IAM & GitHub Secrets Setup

To enable GitHub Actions to deploy to AWS, you need an IAM user with limited permissions and to store its credentials as GitHub secrets.

See [AWS_IAM_SETUP.md](AWS_IAM_SETUP.md) for a full, step-by-step guide.

**Required GitHub secrets:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CLOUDFRONT_DISTRIBUTION_ID`

---

## 🤖 CI/CD: Automatic Deployment with GitHub Actions

Every push to `main` triggers a workflow that:
1. Builds a deployment directory with only website files
2. Syncs files to S3 (removes deleted files)
3. Invalidates CloudFront cache (so changes are live immediately)

**Workflow file:** `.github/workflows/deploy.yml`

**How it works:**
- Only web files are deployed (Terraform, .git, temp files, etc. are ignored)
- Secure: AWS credentials are never stored in code, only as GitHub secrets
- Fast: Only changed files are uploaded

---

## 📝 Best Practices & Tips
- **Never commit AWS credentials or Terraform state to git**
- **Use .gitignore** to keep your repo clean
- **All infrastructure is code**: no manual AWS Console changes
- **Use modular Terraform files** for clarity and reusability
- **Test locally before pushing**
- **Monitor GitHub Actions logs** for deployment status
- **Rotate AWS keys regularly**

---

## 🧩 Customization
- **Change your domain:** Edit `variables.tf` and update Route53/CloudFront settings
- **Add subdomains:** Update `cloudfront.tf` and `route53.tf`
- **Change region:** Edit `variables.tf`
- **Add new sections:** Create new HTML files in `src/` and link them in `index.html`
- **Change design:** Edit `css/styles.css` and assets

---

## 🆘 Troubleshooting
- **DNS not working?** Check NS records at your domain registrar and Route53
- **SSL error?** Ensure ACM certificate is validated and in `us-east-1`
- **S3 access denied?** Check bucket policy and public access settings
- **GitHub Actions failed?** Check logs in the Actions tab
- **CloudFront not updating?** Invalidation may take a few minutes

---

## 📚 Resources
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## 📝 License
MIT

---

## 👤 Author
Ibrahim Kilicaslan

---

## 💡 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## 📚 Resources
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## 📝 License
MIT

---

## 👤 Author
Ibrahim Kilicaslan

---

## 💡 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## ⚠️ Important Note on DNS and ACM Validation

