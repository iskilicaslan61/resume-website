# 🚀 Quick Setup Guide - ismailkilicaslan.de

This guide helps you quickly set up AWS infrastructure for your `ismailkilicaslan.de` domain.

## 📋 Prerequisites

- [ ] AWS account
- [ ] `ismailkilicaslan.de` domain
- [ ] Terraform installed
- [ ] AWS CLI installed and configured

## 🔧 Step 1: Deploy Infrastructure

### For Windows:
```cmd
deploy.bat
```

### For Linux/Mac:
```bash
./deploy.sh
```

### Manually:
```bash
cd terraform-static-website
terraform init
terraform plan
terraform apply
```

## 🌐 Step 2: Configure Domain Registrar

1. **Get nameservers from Terraform output:**
   ```bash
   terraform output route53_nameservers
   ```

2. **Update nameservers in your domain registrar:**
   - Go to your domain registrar's DNS management panel
   - Replace nameservers with values from Terraform
   - Changes can take 24-48 hours to propagate

## 🔐 Step 3: GitHub Actions Setup

### 3.1 Create AWS IAM User

1. **Go to IAM service in AWS Console**
2. **Create a new user:** `github-actions-deploy`
3. **Select Programmatic access**
4. **Add the following policy:**

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

5. **Save the Access Key ID and Secret Access Key**

### 3.2 Add GitHub Secrets

1. **Go to your repository:** https://github.com/iskilicaslan61/resume-website
2. **Settings** → **Secrets and variables** → **Actions**
3. **Add the following secrets:**

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | IAM user's Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | IAM user's Secret Access Key |
| `CLOUDFRONT_DISTRIBUTION_ID` | Distribution ID from Terraform output |

## 🎯 Step 4: Test

1. **Make a small change in the repository**
2. **Commit and push**
3. **Watch the workflow run in GitHub Actions**
4. **Visit https://ismailkilicaslan.de**

## 📁 Project Structure

```
resume-website/
├── index.html              # Main page
├── css/styles.css          # Styles
├── js/scripts.js           # JavaScript
├── assets/                 # Images and icons
├── src/                    # HTML sections
├── terraform-static-website/ # AWS infrastructure
├── .github/workflows/      # GitHub Actions
├── deploy.bat              # Windows deployment script
├── deploy.sh               # Linux/Mac deployment script
└── README.md               # Detailed documentation
```

## 🔧 Editing the Website

- **Main page:** `index.html`
- **Styles:** `css/styles.css`
- **JavaScript:** `js/scripts.js`
- **Images:** `assets/images/`
- **Sections:** HTML files in `src/` directory

## 🆘 Troubleshooting

### DNS not working
- Check that nameservers are set correctly
- Wait 24-48 hours

### GitHub Actions failed
- Check AWS credentials
- Verify CloudFront Distribution ID is correct

### SSL error
- Check that ACM certificate is validated
- Verify CloudFront distribution is active

## 📞 Support

If you encounter issues:
1. Check GitHub Actions logs
2. Look for errors in AWS CloudTrail
3. Check Terraform state

## 🎉 Success!

Your professional CV website is now live at `ismailkilicaslan.de`! Every change you push to GitHub will be automatically updated. 