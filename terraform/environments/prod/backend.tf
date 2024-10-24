terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  cloud {
    organization = "HeliumEdu"
    workspaces {
      name = "prod"
    }
  }

  required_version = ">= 1.2.0"
}