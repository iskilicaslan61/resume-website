# 🟦 Terraform Static Website on AWS

This module provides a complete, modular, and production-ready Infrastructure as Code (IaC) solution for hosting a static website on AWS using S3, CloudFront, Route53, and ACM, all managed with Terraform. It is designed to be clear, reusable, and easy for anyone to adapt for their own projects.

---

## 🚀 Step-by-Step: Deploy Your Static Website on AWS

### **Step 1: Clone the Repository**
```sh
git clone <your-repo-url>
cd terraform-static-website
```

### **Step 2: Configure Your Variables**
- Open `variables.tf` in your editor.
- Set your AWS region, main domain, and all subdomains (aliases):
  - `aws_region`: AWS region (default: `us-east-1`)
  - `domain_name`: Your main domain (e.g. `example.com`)
  - `aliases`: List of all domains/subdomains (e.g. `www.example.com`, `info.example.com`)
- **Tip:** To add a new subdomain, just add it to the `aliases` list. All DNS and CloudFront settings will update automatically!

### **Step 3: Initialize Terraform**
```sh
terraform init
```

### **Step 4: Review the Plan**
```sh
terraform plan
```
- This shows what resources will be created or changed.

### **Step 5: Two-Stage Apply for ACM/Route53 Validation**
If you see errors about ACM DNS validation or for_each arguments, use this two-step process:

**A. First, create only the ACM certificate and Route53 hosted zone:**
```sh
terraform apply -target=aws_acm_certificate.cert -target=aws_route53_zone.main
```
- This creates the certificate and hosted zone, and outputs the DNS validation records.

**B. Then, apply the rest of the infrastructure:**
```sh
terraform apply
```
- This creates the DNS validation records, CloudFront, S3, and all other resources.

### **Step 6: Update Your Domain's NS Records**
- Go to your domain registrar's panel.
- Replace all existing NS (Name Server) records with the four NS records from your Route53 hosted zone (see AWS Console → Route53 → Hosted zones).
- **Important:** DNS propagation can take 5–30 minutes (sometimes longer). ACM validation and HTTPS will not work until this is complete.

### **Step 7: Check the Outputs**
- After apply, Terraform will output:
  - S3 website endpoint
  - CloudFront distribution domain
  - Route53 hosted zone name

### **Step 8: Upload Your Website Files**
- Use the AWS Console or CLI to upload your static website files (index.html, images, etc.) to the S3 bucket.
- Example:
  ```sh
  aws s3 sync ../deploy-dist/ s3://<your-bucket-name> --delete
  ```

### **Step 9: Test Your Website**
- Open your domain in a browser (e.g. `https://yourdomain.com`).
- Check that HTTPS works and your site loads correctly.

---

## 🚀 What Does This Module Do?
- **Creates an S3 bucket** for static website hosting
- **Sets up CloudFront** for global CDN, HTTPS, and custom domains
- **Manages Route53 DNS** (hosted zone, A records, validation records)
- **Requests and validates ACM SSL certificates** (wildcard, auto-DNS validation)
- **Outputs all important endpoints** for easy integration
- **Supports full automation and CI/CD** (see main project README)

---

## 🗂️ File & Module Structure

- `main.tf` – Providers (AWS, regions) and entry point
- `variables.tf` – All variables (region, domain, aliases)
- `s3.tf` – S3 bucket, public access, and policy
- `cert.tf` – ACM wildcard certificate and DNS validation
- `route53.tf` – Hosted zone, DNS records, validation records
- `cloudfront.tf` – CloudFront distribution (CDN, HTTPS, aliases)
- `outputs.tf` – Outputs for endpoints and zone names

---

## 🧩 How to Add a New Subdomain
1. Edit `variables.tf` and add your new subdomain to the `aliases` list:
   ```hcl
   variable "aliases" {
     default = [
       "ibrahimkilicaslan.click",
       "info.ibrahimkilicaslan.click",
       "www.ibrahimkilicaslan.click",
       "newsubdomain.ibrahimkilicaslan.click" # <--- Add here
     ]
   }
   ```
2. Run:
   ```sh
   terraform apply
   ```
3. That's it! All DNS and CloudFront settings update automatically.

---

## 🛡️ Best Practices & Notes
- **Never manually edit AWS Console resources** managed by Terraform.
- **All DNS records** (A, CNAME, etc.) should be managed by this module.
- **ACM certificates for CloudFront** must be created in `us-east-1` (even if your site is in another region).
- **S3 bucket names** must be globally unique.
- **Use version control** for your `.tf` files and keep your state files secure.
- **Delete any manual Route53 records** before applying to avoid conflicts.
- **Force destroy** is enabled for the S3 bucket (for easy cleanup in dev/test). Remove for production if you want to protect data.

---

## 🆘 Troubleshooting & FAQ
- **Terraform apply fails with "already exists"**: There may be a manual record or resource in AWS. Delete it or import it into Terraform.
- **ACM validation stuck**: Check that Route53 CNAME validation records exist and are correct. Make sure your domain's NS records match the Route53 hosted zone.
- **CloudFront not serving HTTPS**: Certificate must be in `us-east-1` and fully validated.
- **S3 access denied**: Check bucket policy and public access block settings.
- **DNS not resolving**: Make sure your domain's NS records at your registrar match the Route53 hosted zone.

---

## 📚 Resources
- [Terraform Documentation](https://www.terraform.io/docs/)
- [AWS S3 Static Website Hosting](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [AWS CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [AWS Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)

---

## 💡 Extra Tips
- This module is designed for learning, prototyping, and production use.
- You can easily extend it for multi-environment (dev/stage/prod) setups by using workspaces or variable overrides.
- For private/static sites, consider using CloudFront Origin Access Control (OAC) or OAI for S3.
- Always review AWS costs before deploying in production.
- Pull requests and suggestions are welcome!

## 📄 Explanation of Each File

---

## 🗑️ How to Remove a Resource from Terraform State (State Management)

If you need to remove a resource from Terraform state (for example, after deleting it manually in AWS), follow these steps:

### 1. List All Resources in State
Run:
```sh
terraform state list
```
This command shows all resources currently tracked in your state file.

### 2. Find the Correct Resource Address
Look for a line similar to:
```
aws_route53_record.cert_validation["your-key"]
```
or
```
aws_route53_record.cert_validation
```
or another resource name.

### 3. Copy the Exact Address
Copy the full line exactly as shown in the output.

### 4. Remove the Resource from State
Run:
```sh
terraform state rm 'paste-the-exact-address-here'
```
**Example:**
```sh
terraform state rm 'aws_route53_record.cert_validation["your-key"]'
```
or
```sh
terraform state rm aws_route53_record.cert_validation
```
(Use quotes if the address contains special characters or brackets)

### 5. If You Can't Find the Resource
If the resource is not listed in the state, you do not need to remove it.
You can safely continue with:
```sh
terraform apply
```

## 📝 License
MIT

---

## 👤 Author
Ibrahim Kilicaslan