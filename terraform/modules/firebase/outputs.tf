output "project_id" {
  description = "Firebase project ID"
  value       = var.firebase_project_id
}

output "project_number" {
  description = "Firebase project number"
  value       = data.google_project.helium.number
}

# Web App outputs
output "web_app_id" {
  description = "Firebase Web App ID"
  value       = google_firebase_web_app.helium_web.app_id
}

output "web_api_key" {
  description = "Firebase Web API Key"
  value       = data.google_firebase_web_app_config.helium_web.api_key
  sensitive   = true
}

output "web_auth_domain" {
  description = "Firebase Web Auth Domain"
  value       = data.google_firebase_web_app_config.helium_web.auth_domain
}

output "web_messaging_sender_id" {
  description = "Firebase Web Messaging Sender ID"
  value       = data.google_firebase_web_app_config.helium_web.messaging_sender_id
}

output "web_storage_bucket" {
  description = "Firebase Web Storage Bucket"
  value       = data.google_firebase_web_app_config.helium_web.storage_bucket
}

output "web_measurement_id" {
  description = "Firebase Web Measurement ID"
  value       = data.google_firebase_web_app_config.helium_web.measurement_id
}

# Android App outputs
output "android_app_id" {
  description = "Firebase Android App ID"
  value       = google_firebase_android_app.helium_android.app_id
}

output "android_api_key" {
  description = "Firebase Android API Key"
  value       = jsondecode(data.google_firebase_android_app_config.helium_android.config_file_contents)["client"][0]["api_key"][0]["current_key"]
  sensitive   = true
}

# iOS App outputs
output "ios_app_id" {
  description = "Firebase iOS App ID"
  value       = google_firebase_apple_app.helium_ios.app_id
}

output "ios_api_key" {
  description = "Firebase iOS API Key"
  value       = jsondecode(data.google_firebase_apple_app_config.helium_ios.config_file_contents)["API_KEY"]
  sensitive   = true
}

output "ios_client_id" {
  description = "Firebase iOS Client ID"
  value       = jsondecode(data.google_firebase_apple_app_config.helium_ios.config_file_contents)["CLIENT_ID"]
  sensitive   = true
}

# Full config files (for generating google-services.json and GoogleService-Info.plist)
output "android_config_file" {
  description = "Complete Android google-services.json content"
  value       = data.google_firebase_android_app_config.helium_android.config_file_contents
  sensitive   = true
}

output "ios_config_file" {
  description = "Complete iOS GoogleService-Info.plist content"
  value       = data.google_firebase_apple_app_config.helium_ios.config_file_contents
  sensitive   = true
}
