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

### Variables defined below this point must have their defaults defined in the Terraform Workspace

variable "aws_account_id" {
  description = "The AWS account ID"
}

variable "helium_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}

variable "ci_twiml_handler_url" {
  description = "The URL for the TwiML Bin"
}

variable "DD_API_KEY" {
  default = "The DataDog API key"
}
variable "DD_APP_KEY" {
  default = "The DataDog app key"
}
variable "PLATFORM_DB_USER" {
  default = "The MySQL DB username"
}
variable "PLATFORM_DB_PASSWORD" {
  default = "The MySQL DB password"
}
variable "PLATFORM_SECRET_PROD" {
  default = "The Django secret"
}
variable "ROLLBAR_API_KEY" {
  default = "The Rollbar API key"
}
variable "TWILIO_ACCOUNT_SID" {
  default = "The Twilio account SID"
}
variable "TWILIO_AUTH_TOKEN" {
  default = "The Twilio auth token"
}