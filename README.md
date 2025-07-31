# CV Website – Automated Static Site on AWS with Terraform & GitHub Actions

This project is a fully automated, professional CV (resume) website on AWS. It uses Infrastructure as Code (IaC) with Terraform and continuous deployment with GitHub Actions. The site is globally accessible, secure (HTTPS), and easy to update—just push to GitHub!

**🌐 Website:** https://ismailkilicaslan.de  
**📦 GitHub Repository:** https://github.com/iskilicaslan61/resume-website

---

## 🚀 Features

* **Modern, responsive CV website** (HTML, CSS, JS, images, assets)
* **AWS S3** for static website hosting
* **AWS CloudFront** for CDN, HTTPS, and custom domains
* **AWS Route53** for DNS management
* **AWS ACM** for free SSL certificates (wildcard support)
* **Terraform** for modular, repeatable infrastructure
* **GitHub Actions** for automatic deployment (CI/CD)
* **Best practices** for security, automation, and maintainability

---

## 🗂️ Project Structure

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

## 🛠️ Local Development

1. **Clone the repository:**  
   ```bash
   git clone https://github.com/iskilicaslan61/resume-website.git
   cd resume-website
   ```

2. **Edit your website:**  
   * Main file: `index.html`  
   * Styles: `css/styles.css`  
   * JavaScript: `js/scripts.js`  
   * Images: `assets/images/`  
   * Modular HTML: `src/`

3. **Preview locally:**  
   * Use VS Code Live Server or preview with `python3 -m http.server`.

---

## ☁️ Infrastructure as Code (Terraform)

All AWS resources are managed with Terraform for complete reproducibility and automation.

### **Automated Components:**

* S3 bucket for static hosting
* CloudFront distribution (CDN, HTTPS)
* Route53 hosted zone and DNS records
* ACM SSL certificate (wildcard, auto-validation)

### **Deploying Infrastructure:**

1. **Install Terraform:** https://terraform.io/downloads
2. **Configure AWS credentials** (`aws configure` or environment variables)
3. **Edit variables:**  
   * `terraform-static-website/variables.tf` (set domain, region, etc.)
4. **Initialize Terraform:**  
   ```bash
   cd terraform-static-website
   terraform init
   ```
5. **Review the plan:**  
   ```bash
   terraform plan
   ```
6. **Apply infrastructure:**  
   ```bash
   terraform apply
   ```
7. **Check outputs:**  
   * S3 website endpoint  
   * CloudFront domain  
   * Route53 zone name
   * **Route53 nameservers** (required for domain registrar)

> **Important Notes:**
> 
> * All DNS records should be managed by Terraform. Delete manual records in Route53 before applying.
> * ACM certificates for CloudFront must be created in `us-east-1`.
> * S3 bucket names must be globally unique.

---

## 🔐 AWS IAM & GitHub Secrets Setup

For GitHub Actions to deploy to AWS, you need a limited-permission IAM user and store their credentials as GitHub secrets.

See the `AWS_IAM_SETUP.md` file for detailed step-by-step guide.

**Required GitHub secrets:**

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `CLOUDFRONT_DISTRIBUTION_ID`

---

## 🌐 Domain Registrar Configuration

To point your `ismailkilicaslan.de` domain to AWS Route53:

1. **Get nameservers from Terraform output:**
   ```bash
   terraform output route53_nameservers
   ```

2. **Update nameservers in your domain registrar:**
   * Go to your domain registrar's DNS management panel
   * Replace existing NS (Name Server) records with the four NS records from Terraform
   * **Important:** DNS propagation can take 24-48 hours

---

## 🤖 CI/CD: Automatic Deployment with GitHub Actions

Every push to the `main` branch triggers a workflow that:

1. Creates a deployment directory from website files
2. Syncs files to S3 (removes deleted files)
3. Invalidates CloudFront cache (changes go live immediately)

**Workflow file:** `.github/workflows/deploy.yml`

**How it works:**

* Only web files are deployed (Terraform, .git, temp files, etc. are ignored)
* Secure: AWS credentials are never stored in code, only as GitHub secrets
* Fast: Only changed files are uploaded

---

## 📝 Best Practices & Tips

* **Never commit AWS credentials or Terraform state to git**
* **Use .gitignore** to keep your repository clean
* **All infrastructure as code**: Don't make manual changes in AWS Console
* **Use modular Terraform files** for clarity and reusability
* **Test locally before pushing**
* **Monitor GitHub Actions logs for deployment status**
* **Rotate AWS keys regularly**

---

## 🧩 Customization

* **Change your domain:** Edit `variables.tf` and update Route53/CloudFront settings
* **Add subdomains:** Update `cloudfront.tf` and `route53.tf`
* **Change region:** Edit `variables.tf`
* **Add new sections:** Create new HTML files in `src/` and link them in `index.html`
* **Change design:** Edit `css/styles.css` and assets

---

## 🆘 Troubleshooting

* **DNS not working?** Check NS records in your domain registrar and Route53
* **SSL error?** Make sure ACM certificate is validated and in `us-east-1`
* **S3 access denied?** Check bucket policy and public access settings
* **GitHub Actions failed?** Check logs in the Actions tab
* **CloudFront not updating?** Invalidation can take a few minutes

---

## 📚 Resources

* [Terraform Documentation](https://www.terraform.io/docs)
* [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
* [AWS CloudFront](https://docs.aws.amazon.com/cloudfront/)
* [AWS Route53](https://docs.aws.amazon.com/route53/)
* [GitHub Actions](https://docs.github.com/en/actions)

---

## 📝 License

MIT

---

## 👤 Author

İsmail Kılıçaslan

---

## 💡 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

