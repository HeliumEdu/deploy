provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = true
    }
  }
}

provider "google-beta" {
  project = var.FIREBASE_PROJECT_ID
  # Credentials from GOOGLE_CREDENTIALS environment variable
}
