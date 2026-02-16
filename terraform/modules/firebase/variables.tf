variable "firebase_project_id" {
  description = "The Firebase project ID"
  type        = string
}

variable "android_package_name" {
  description = "Android app package name"
  type        = string
  default     = "com.heliumedu.heliumapp"
}

variable "ios_bundle_id" {
  description = "iOS app bundle ID"
  type        = string
  default     = "com.heliumedu.heliumapp"
}

variable "ios_app_store_id" {
  description = "iOS App Store ID"
  type        = string
  default     = "6758323154"
}
