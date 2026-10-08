# Deploying your portfolio on AWS (S3 + CloudFront + Route 53)

```
Visitor -> Route 53 (DNS) -> CloudFront (CDN + HTTPS) -> S3 (private bucket with your files)
```

Your bucket stays **private**. Only CloudFront can read it, using an Origin Access Control (OAC). This is the recommended, safer setup.

Placeholders used below: `YOUR_BUCKET_NAME`, `YOUR_DOMAIN.com`, `YOUR_DISTRIBUTION_ID`, `YOUR_ACCOUNT_ID`. Replace them with your own values.

## Step 0: Secure your AWS account first

1. Sign in as the **root user** only once. Turn on **MFA** for root (IAM > Dashboard > Add MFA).
2. Create a day-to-day user or IAM Identity Center user with MFA. Do not use root for daily work.
3. Set a **budget alert** (Billing > Budgets > Create budget, for example a small monthly amount) so you are warned about unexpected charges.

## Step 1: Create the S3 bucket

1. AWS Console > **S3** > **Create bucket**.
2. Bucket name: globally unique, lowercase, for example `kanagamalar-portfolio-<something unique>`.
3. Region: choose one close to you (for example Asia Pacific (Mumbai) `ap-south-1`).
4. **Block all public access: leave ON** (all four boxes checked).
5. Leave default encryption on. Create the bucket.

You do **not** need to turn on "Static website hosting". CloudFront reads the bucket directly through OAC.

## Step 2: Upload the website files

1. Open the bucket > **Upload** > add `index.html`, `style.css`, `script.js` and the `assets/` folder (with `profile.jpg` and `Kanagamalar_C_Resume.pdf`).
2. Do **not** upload `docs/`, `.git`, `deploy.sh` or any `.env` file.

## Step 3: Create the CloudFront distribution

1. AWS Console > **CloudFront** > **Create distribution**.
2. **Origin domain**: pick your S3 bucket from the list.
3. **Origin access**: choose **Origin access control settings (recommended)** > create a new OAC (defaults are fine).
4. **Viewer protocol policy**: **Redirect HTTP to HTTPS**.
5. **Cache policy**: CachingOptimized. Turn on **Compress objects automatically**.
6. **Default root object**: `index.html`.
7. Create the distribution. CloudFront shows a banner: **Copy policy** for the bucket.
8. Go to S3 > your bucket > **Permissions** > **Bucket policy** > paste the copied policy and save. It looks like this:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipalReadOnly",
      "Effect": "Allow",
      "Principal": { "Service": "cloudfront.amazonaws.com" },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/YOUR_DISTRIBUTION_ID"
        }
      }
    }
  ]
}
```

9. Wait until the distribution status says **Deployed** (a few minutes). Open `https://<your-distribution>.cloudfront.net` to test. HTTPS works immediately on this default domain.

**If you see 403 AccessDenied:** check the bucket policy, confirm `index.html` is uploaded at the bucket root, and confirm the default root object is `index.html`.

## Step 4: Add a custom domain with HTTPS

1. **Get a domain.** Register one in **Route 53 > Registered domains**, or use a registrar of your choice. Your domain here is `YOUR_DOMAIN.com`.
2. **Create a hosted zone** in Route 53 for `YOUR_DOMAIN.com` (automatic if you registered it there). If you registered elsewhere, copy the 4 Route 53 name servers into your registrar.
3. **Request a certificate in us-east-1.** CloudFront only accepts certificates from **N. Virginia (us-east-1)**. Switch the console region, open **AWS Certificate Manager** > **Request** > public certificate for `YOUR_DOMAIN.com` and `www.YOUR_DOMAIN.com` > **DNS validation**. Click **Create records in Route 53**. Wait for status **Issued**.
4. **Attach to CloudFront.** Distribution > **Settings > Edit**: add alternate domain names `YOUR_DOMAIN.com` and `www.YOUR_DOMAIN.com`, and select the certificate. Save.
5. **Point DNS to CloudFront.** Route 53 > hosted zone > **Create record**:
   - Name empty (root), Type **A**, **Alias** on, target **CloudFront distribution**, choose yours.
   - Repeat with Type **AAAA** (IPv6), and again for `www`.
6. Visit `https://YOUR_DOMAIN.com` once DNS propagates.

## Step 5: Basic security checklist

- Bucket **stays private**, Block Public Access ON.
- MFA on root and on your daily user.
- Add a **response headers policy** to the distribution (Behaviors > Edit > Response headers policy > `SecurityHeadersPolicy`) for HSTS and related headers.
- Turn on **CloudTrail** (default event history is on) and keep the budget alert.
- Never commit AWS access keys. Use `aws configure sso` or `aws configure` on your own computer only.

### Least-privilege policy for the person who deploys

Attach this to your deploy user (not `AdministratorAccess`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"],
      "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*"
    },
    {
      "Effect": "Allow",
      "Action": ["cloudfront:CreateInvalidation"],
      "Resource": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/YOUR_DISTRIBUTION_ID"
    }
  ]
}
```

## Step 6: Updating the website after changes

CloudFront caches your files, so after uploading you must **invalidate** the cache.

**Console method:** S3 > upload changed files (replace existing). Then CloudFront > your distribution > **Invalidations** > **Create invalidation** > path `/*`.

**CLI method** (after installing the AWS CLI and running `aws configure sso`):

```bash
aws s3 sync . s3://YOUR_BUCKET_NAME --delete \
  --exclude ".git/*" --exclude "docs/*" --exclude "README.md" --exclude "deploy.sh" --exclude ".env*"
aws cloudfront create-invalidation --distribution-id YOUR_DISTRIBUTION_ID --paths "/*"
```

Or use the included `deploy.sh` after setting `BUCKET_NAME` and `DISTRIBUTION_ID` environment variables.

## After deploying

- Replace `YOUR_PORTFOLIO_URL` in `index.html` and add a `<link rel="canonical">` tag with your real URL.
- Add the portfolio URL to your GitHub profile and README.
- Costs for a small static site are normally low, but always check the AWS pricing pages and your budget alerts.
