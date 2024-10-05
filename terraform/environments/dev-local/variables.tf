variable "environment" {
  description = "The environment"
  default     = "dev-local"
}

variable "environment_prefix" {
  description = "Env when used as a prefix for things like hostname (empty when prod)"
  default     = "dev"
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