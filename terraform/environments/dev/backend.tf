terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.18"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.0"
    }
  }
  cloud {
    organization = "HeliumEdu"
    workspaces {
      name = "dev"
    }
  }

  required_version = ">= 1.5.0"
}