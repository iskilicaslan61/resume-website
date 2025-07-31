# AWS IAM Setup Guide for GitHub Actions Deployment

This guide explains how to create the necessary IAM user and policies for GitHub Actions to deploy to AWS.

## 🎯 Objective

To provide the necessary permissions for your GitHub Actions workflow to perform the following operations:
- Upload files to S3 bucket
- CloudFront cache invalidation
- Only the minimum required permissions

## 📋 Step-by-Step Setup

### 1. Creating AWS IAM User

1. **Log into AWS Console** and go to IAM service
2. **Click on "Users"** tab
3. **Click "Create user"** button
4. **Enter username:** `github-actions-deploy`
5. **Check "Programmatic access"** option
6. **Click "Next: Permissions"** button

### 2. Creating IAM Policy

1. **Select "Attach policies directly"** option
2. **Click "Create policy"** button
3. **Click on "JSON"** tab
4. **Paste the following policy:**

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

5. **Click "Next: Tags"** button (optional)
6. **Click "Next: Review"** button
7. **Enter policy name:** `GitHubActionsDeployPolicy`
8. **Click "Create policy"** button

### 3. Adding Policy to User

1. **Go back to your created user**
2. **Select "Attach policies directly"** option
3. **In the search box** type `GitHubActionsDeployPolicy`
4. **Select the policy** and click **"Next: Review"** button
5. **Click "Create user"** button

### 4. Creating Access Keys

1. **Click on the created user**
2. **Click on "Security credentials"** tab
3. **Click "Create access key"** button
4. **Select "Application running outside AWS"** option
5. **Click "Next"** button
6. **Click "Create access key"** button
7. **Save the Access Key ID and Secret Access Key**

> ⚠️ **IMPORTANT:** Secret Access Key is shown only once. Save it in a secure place!

## 🔐 GitHub Secrets Setup

### 1. Go to GitHub Repository

1. **Go to your repository:** https://github.com/iskilicaslan61/resume-website
2. **Click on "Settings"** tab
3. **From left menu select "Secrets and variables"** → **"Actions"**

### 2. Adding Secrets

Add the following 3 secrets:

#### AWS_ACCESS_KEY_ID
- **Name:** `AWS_ACCESS_KEY_ID`
- **Value:** Access Key ID from your IAM user

#### AWS_SECRET_ACCESS_KEY
- **Name:** `AWS_SECRET_ACCESS_KEY`
- **Value:** Secret Access Key from your IAM user

#### CLOUDFRONT_DISTRIBUTION_ID
- **Name:** `CLOUDFRONT_DISTRIBUTION_ID`
- **Value:** CloudFront distribution ID (to be obtained from Terraform output)

### 3. Getting CloudFront Distribution ID

After running Terraform:

```bash
cd terraform-static-website
terraform output cloudfront_distribution_id
```

Add the output of this command to the `CLOUDFRONT_DISTRIBUTION_ID` secret.

## 🔍 Testing

### 1. Make a Test Commit

```bash
# Clone your repository (if you haven't already)
git clone https://github.com/iskilicaslan61/resume-website.git
cd resume-website

# Make a small change
echo "# Test" >> README.md

# Commit and push
git add README.md
git commit -m "Test deployment"
git push origin main
```

### 2. Monitor GitHub Actions

1. **Go to "Actions"** tab in your repository
2. **Wait for the workflow to run**
3. **Check if it was successful**

## 🛡️ Security Best Practices

### 1. Principle of Least Privilege
- User has only the minimum required permissions
- Access only to specific S3 bucket
- Only CloudFront invalidation permission

### 2. Regular Key Rotation
- Rotate access keys regularly (every 3-6 months)
- Delete old keys immediately

### 3. Monitoring
- Monitor API calls with CloudTrail
- Check for abnormal activities

## 🆘 Troubleshooting

### "Access Denied" Error
- Make sure IAM policy is correctly attached
- Check that S3 bucket name is correct
- Verify CloudFront distribution ID is correct

### "Invalid credentials" Error
- Check that access keys are copied correctly
- Verify GitHub secrets are named correctly

### "Distribution not found" Error
- Check that CloudFront distribution ID is current
- Re-run Terraform and get the new ID

## 📚 Additional Resources

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [GitHub Actions Security](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [AWS S3 Permissions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-with-s3-actions.html)
- [CloudFront Invalidation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html) 