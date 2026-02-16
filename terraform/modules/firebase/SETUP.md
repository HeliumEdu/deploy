# Firebase Terraform Setup Guide

## Overview

Your Firebase configuration is now managed by Terraform! This guide will walk you through the initial setup.

## Step 1: Credentials (Already Done! ✅)

**Good news!** Your Firebase credentials are already configured in Terraform Cloud workspace variables:
- `FIREBASE_PROJECT_ID`
- `FIREBASE_PRIVATE_KEY_ID`
- `FIREBASE_PRIVATE_KEY`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_CLIENT_ID`
- `FIREBASE_CLIENT_X509_CERT_URL`

The Terraform provider is configured to automatically construct the service account JSON from these variables using `jsonencode()`. **No additional setup needed!**

### Optional: Verify Service Account Permissions

Check if your service account has Firebase Admin permissions:
```bash
# Get the client email
CLIENT_EMAIL="firebase-adminsdk-fbsvc@helium-edu.iam.gserviceaccount.com"

# Check if it has the Firebase Admin role
gcloud projects get-iam-policy helium-edu \
  --flatten="bindings[].members" \
  --format="table(bindings.role)" \
  --filter="bindings.members:serviceAccount:${CLIENT_EMAIL}"
```

If you don't see `roles/firebase.admin`, add it:
```bash
gcloud projects add-iam-policy-binding helium-edu \
  --member="serviceAccount:${CLIENT_EMAIL}" \
  --role="roles/firebase.admin"
```

## Step 2: Import Existing Firebase Apps

Your Firebase apps already exist, so we need to import them into Terraform state:

```bash
cd terraform/environments/prod

# Initialize with the new Google provider
terraform init

# Import existing Firebase apps
terraform import 'module.firebase.google_firebase_web_app.helium_web' \
  helium-edu/1:643279973445:web:18d70bb986764d56dec72c

terraform import 'module.firebase.google_firebase_android_app.helium_android' \
  helium-edu/1:643279973445:android:7aa8c18979aa72bedec72c

terraform import 'module.firebase.google_firebase_apple_app.helium_ios' \
  helium-edu/1:643279973445:ios:1fad59583ee04ad2dec72c
```

## Step 3: Plan and Apply

```bash
# See what Terraform will manage
terraform plan

# Apply the configuration
terraform apply
```

## Step 4: Configure Authorized Domains in Firebase Console

Terraform cannot manage Firebase Auth authorized domains, so you need to add them manually:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select the `helium-edu` project
3. Navigate to **Authentication → Settings → Authorized domains**
4. Click **Add domain** and add:
   - `auth.heliumedu.com`
   - `app.heliumedu.com`
   - `api.heliumedu.com`
   - (Optional) `auth.dev.heliumedu.com` for dev environment

## Step 5: Configure OAuth Providers

If not already configured, set up OAuth providers:

### Google Sign-In
1. Firebase Console → **Authentication → Sign-in method**
2. Enable **Google** provider
3. Add your OAuth client IDs from Google Cloud Console

### Apple Sign-In
1. Firebase Console → **Authentication → Sign-in method**
2. Enable **Apple** provider
3. Add your Apple Service ID and key

## What's Now Managed by Terraform?

✅ Firebase Web App registration
✅ Firebase Android App registration
✅ Firebase iOS App registration
✅ App configuration exports (API keys, project IDs, etc.)

## What's Still Manual?

❌ OAuth provider configuration (Google, Apple)
❌ Authorized domains
❌ Service account keys (store in AWS Secrets Manager)
❌ Firebase Cloud Messaging server keys
❌ Analytics settings

## Future: Generating Config Files from Terraform

Once imported, you can regenerate your frontend config files from Terraform:

```bash
# Generate google-services.json
terraform output -raw module.firebase.android_config_file > \
  ../../../projects/frontend/android/app/google-services.json

# Generate GoogleService-Info.plist
terraform output -raw module.firebase.ios_config_file > \
  ../../../projects/frontend/ios/Runner/GoogleService-Info.plist
```

## Troubleshooting

### "Error 403: The caller does not have permission"
- Make sure your service account has the `roles/firebase.admin` role
- Verify `GOOGLE_CREDENTIALS` is set correctly in Terraform Cloud

### "Resource already exists"
- You need to import the existing resources first (see Step 2)

### "Invalid import ID format"
- Ensure you're using the exact format: `project-id/app-id`
- App IDs can be found in Firebase Console or your current config files
