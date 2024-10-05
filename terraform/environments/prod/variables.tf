variable "environment" {
  description = "The environment"
  default     = "prod"
}

variable "environment_prefix" {
  description = "Prefix used for env in hostnames (empty string when `prod`)"
  default     = ""
}

variable "aws_region" {
  description = "The AWS region"
  default = "us-east-1"
}

variable "area_code" {
  description = "The area code for the phone number"
  default     = "650"
}

### Variables defined below this point must have their defaults defined in the Terraform Workspace

variable "helium_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}

variable "ci_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}