terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

# Firebase project (import existing)
data "google_project" "helium" {
  project_id = var.firebase_project_id
}

# Firebase Web App
resource "google_firebase_web_app" "helium_web" {
  provider     = google
  project      = var.firebase_project_id
  display_name = "Helium Web App"

  lifecycle {
    prevent_destroy = true
  }
}

# Get Web App config
data "google_firebase_web_app_config" "helium_web" {
  provider   = google
  project    = var.firebase_project_id
  web_app_id = google_firebase_web_app.helium_web.app_id
}

# Firebase Android App
resource "google_firebase_android_app" "helium_android" {
  provider     = google
  project      = var.firebase_project_id
  display_name = "Helium Android App"
  package_name = var.android_package_name

  lifecycle {
    prevent_destroy = true
  }
}

# Get Android App config (includes google-services.json data)
data "google_firebase_android_app_config" "helium_android" {
  provider   = google
  project    = var.firebase_project_id
  app_id     = google_firebase_android_app.helium_android.app_id
}

# Firebase iOS App
resource "google_firebase_apple_app" "helium_ios" {
  provider     = google
  project      = var.firebase_project_id
  display_name = "Helium iOS App"
  bundle_id    = var.ios_bundle_id
  app_store_id = var.ios_app_store_id

  lifecycle {
    prevent_destroy = true
  }
}

# Get iOS App config (includes GoogleService-Info.plist data)
data "google_firebase_apple_app_config" "helium_ios" {
  provider   = google
  project    = var.firebase_project_id
  app_id     = google_firebase_apple_app.helium_ios.app_id
}

# Note: Firebase Authentication configuration (providers, authorized domains)
# must still be configured manually or via Firebase Console/CLI as Terraform
# support is limited. Add auth.heliumedu.com to authorized domains manually.
