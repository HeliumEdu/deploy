provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = true
    }
  }
}

provider "google" {
  project = var.FIREBASE_PROJECT_ID
  credentials = jsonencode({
    type                        = "service_account"
    project_id                  = var.FIREBASE_PROJECT_ID
    private_key_id              = var.FIREBASE_PRIVATE_KEY_ID
    private_key                 = var.FIREBASE_PRIVATE_KEY
    client_email                = var.FIREBASE_CLIENT_EMAIL
    client_id                   = var.FIREBASE_CLIENT_ID
    auth_uri                    = "https://accounts.google.com/o/oauth2/auth"
    token_uri                   = "https://oauth2.googleapis.com/token"
    auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs"
    client_x509_cert_url        = var.FIREBASE_CLIENT_X509_CERT_URL
    universe_domain             = "googleapis.com"
  })
}
