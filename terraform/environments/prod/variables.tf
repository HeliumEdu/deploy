variable "helium_version" {
  description = "The container version. Bumping this will trigger a deploy."
  default     = "1.7.10"
}

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
  default     = "us-east-1"
}

variable "helium_area_code" {
  description = "The area code for the Helium phone number"
  type        = string
  default     = "415"
}

variable "ci_area_code" {
  description = "The area code for the CI phone number"
  type        = string
  default     = "650"
}

### Variables defined below this point must have their defaults defined in the Terraform Workspace

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
}

variable "TWILIO_ACCOUNT_SID" {
  description = "The Twilio account SID"
}

variable "TWILIO_AUTH_TOKEN" {
  description = "The Twilio auth token"
}

variable "helium_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}

variable "ci_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}

variable "DD_API_KEY" {
  description = "The DataDog API key"
}

variable "DD_APP_KEY" {
  description = "The DataDog app key"
}

variable "ROLLBAR_API_KEY" {
  description = "The Rollbar API key"
}