#!/bin/bash
set -e

# Generate Firebase service account JSON from Terraform Cloud variables
# This script creates the credentials file needed for Terraform Google provider

ENVIRONMENT=${1:-prod}

echo "Generating Firebase service account JSON for environment: $ENVIRONMENT"

# Get the Terraform workspace variables
cd terraform/environments/$ENVIRONMENT

echo "Fetching Firebase credentials from Terraform Cloud..."

# Method 1: Using Terraform outputs (if you expose them)
# FIREBASE_PROJECT_ID=$(terraform output -raw FIREBASE_PROJECT_ID)
# Or Method 2: Get from AWS Secrets Manager directly
# aws secretsmanager get-secret-value --secret-id ${ENVIRONMENT}/helium --query SecretString --output text | jq -r '.PLATFORM_FIREBASE_PROJECT_ID'

# For now, create template and instructions
cat > firebase-service-account.json <<EOF
{
  "type": "service_account",
  "project_id": "REPLACE_WITH_FIREBASE_PROJECT_ID",
  "private_key_id": "REPLACE_WITH_FIREBASE_PRIVATE_KEY_ID",
  "private_key": "REPLACE_WITH_FIREBASE_PRIVATE_KEY",
  "client_email": "REPLACE_WITH_FIREBASE_CLIENT_EMAIL",
  "client_id": "REPLACE_WITH_FIREBASE_CLIENT_ID",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "REPLACE_WITH_FIREBASE_CLIENT_X509_CERT_URL",
  "universe_domain": "googleapis.com"
}
EOF

echo ""
echo "✅ Template created at: firebase-service-account.json"
echo ""
echo "Next steps:"
echo "1. Get your Firebase credentials from AWS Secrets Manager:"
echo "   aws secretsmanager get-secret-value --secret-id ${ENVIRONMENT}/helium --query SecretString --output text | jq"
echo ""
echo "2. Replace the placeholders in firebase-service-account.json with actual values"
echo ""
echo "3. Use with Terraform:"
echo "   export GOOGLE_CREDENTIALS=\$(cat firebase-service-account.json)"
echo "   terraform plan"
echo ""
echo "⚠️  Make sure to add firebase-service-account.json to .gitignore!"
