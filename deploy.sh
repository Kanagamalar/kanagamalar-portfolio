#!/usr/bin/env bash
# Optional helper: upload the site to S3 and clear the CloudFront cache.
# Usage:
#   export BUCKET_NAME=your-bucket-name
#   export DISTRIBUTION_ID=YOUR_DISTRIBUTION_ID
#   ./deploy.sh
# Credentials come from your local AWS CLI profile (aws configure / aws configure sso).
# Never put access keys in this file.
set -euo pipefail

: "${BUCKET_NAME:?Set BUCKET_NAME first}"
: "${DISTRIBUTION_ID:?Set DISTRIBUTION_ID first}"

# Long cache for static assets, short cache for HTML so edits show up quickly
aws s3 sync . "s3://${BUCKET_NAME}" --delete \
  --exclude ".git/*" --exclude ".gitignore" --exclude "docs/*" \
  --exclude "README.md" --exclude "deploy.sh" --exclude ".env*" \
  --exclude "*.html" --cache-control "public,max-age=86400"

aws s3 sync . "s3://${BUCKET_NAME}" \
  --exclude "*" --include "*.html" \
  --cache-control "public,max-age=300" --content-type "text/html; charset=utf-8"

aws cloudfront create-invalidation --distribution-id "${DISTRIBUTION_ID}" --paths "/*"
echo "Deployed."
