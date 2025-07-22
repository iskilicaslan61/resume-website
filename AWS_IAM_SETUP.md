# AWS IAM User Setup - GitHub Actions CI/CD

This guide contains the steps to create the necessary AWS IAM user and policies for GitHub Actions CI/CD pipeline.

## 🎯 Purpose
Create a secure IAM user for GitHub Actions to upload files to S3 bucket and clear CloudFront cache.

## 📋 Requirements
- AWS account access
- IAM administrator permissions
- GitHub repository

---

## 🔧 Step 1: Create IAM Policy

### 1.1 Access AWS Console
1. Log into AWS Console
2. Go to IAM service
3. Select "Policies" from the left menu

### 1.2 Create New Policy
1. Click "Create policy" button
2. Select JSON tab
3. Paste the following JSON code:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "S3Access",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::ibrahimkilicaslan.click",
                "arn:aws:s3:::ibrahimkilicaslan.click/*"
            ]
        },
        {
            "Sid": "CloudFrontInvalidation",
            "Effect": "Allow",
            "Action": [
                "cloudfront:CreateInvalidation",
                "cloudfront:GetInvalidation",
                "cloudfront:ListInvalidations"
            ],
            "Resource": "arn:aws:cloudfront::*:distribution/*"
        }
    ]
}
```

### 1.3 Save Policy
1. Click "Next: Tags" button
2. Click "Next: Review" button
3. Policy name: `GitHubActionsDeployPolicy`
4. Description: `Policy for GitHub Actions to deploy website to S3 and invalidate CloudFront`
5. Click "Create policy" button

---

## 👤 Step 2: Create IAM User

### 2.1 Create New User
1. Go to "Users" tab in IAM
2. Click "Create user" button
3. Username: `github-actions-deploy`
4. Click "Next: Permissions" button

### 2.2 Add Policy
1. Select "Attach policies directly" option
2. Search for `GitHubActionsDeployPolicy` in the search box
3. Select the policy you created
4. Click "Next: Tags" button

### 2.3 Create User
1. Click "Next: Review" button
2. Click "Create user" button

---

## 🔑 Step 3: Create Access Keys

### 3.1 Create Access Key
1. Click on the user you created
2. Go to "Security credentials" tab
3. Click "Create access key" button
4. Select "Command Line Interface (CLI)" option
5. Click "Next" button
6. Click "Create access key" button

### 3.2 Save Information
**IMPORTANT:** Save this information in a secure place, it's only shown once!

```
Access key ID: AKIA...
Secret access key: ...
```

---

## 🌐 Step 4: Find CloudFront Distribution ID

### 4.1 Go to CloudFront Console
1. Go to CloudFront service in AWS Console
2. Find your distribution in the distribution list
3. Copy the Distribution ID (e.g., E2L4OJ7JSVABJ)

---

## 🔐 Step 5: Configure GitHub Secrets

### 5.1 Go to GitHub Repository
1. Go to your repository on GitHub
2. Click "Settings" tab
3. Select "Secrets and variables" > "Actions" from the left menu

### 5.2 Add Secrets
Add the following 3 secrets:

#### AWS_ACCESS_KEY_ID
1. Click "New repository secret" button
2. Name: `AWS_ACCESS_KEY_ID`
3. Value: IAM user's Access Key ID
4. Click "Add secret" button

#### AWS_SECRET_ACCESS_KEY
1. Click "New repository secret" button
2. Name: `AWS_SECRET_ACCESS_KEY`
3. Value: IAM user's Secret Access Key
4. Click "Add secret" button

#### CLOUDFRONT_DISTRIBUTION_ID
1. Click "New repository secret" button
2. Name: `CLOUDFRONT_DISTRIBUTION_ID`
3. Value: CloudFront distribution ID
4. Click "Add secret" button

---

## ✅ Testing

### 5.1 Test Commit
1. Modify any website file in the repository
2. Commit and push
3. Go to "Actions" tab on GitHub
4. Check if the workflow runs

### 5.2 Result Verification
- Workflow completed successfully ✅
- Files updated in S3 bucket ✅
- Website changes visible ✅

---

## 🔒 Security Notes

- **Never commit Access Keys to public repositories**
- **Rotate Access Keys regularly**
- **Apply principle of least privilege**
- **Monitor activities with CloudTrail**

---

## 🚨 Troubleshooting

### Access Error
- Ensure IAM policy targets the correct bucket and distribution
- Check if Access Keys are correct

### CloudFront Invalidation Error
- Verify Distribution ID is correct
- Ensure CloudFront permissions are in IAM policy

### S3 Sync Error
- Check if bucket name is correct
- Ensure S3 permissions are in IAM policy

---

## 📞 Support

If you encounter any issues:
1. Check GitHub Actions logs
2. Search for errors in AWS CloudTrail
3. Re-check IAM policy and user permissions 