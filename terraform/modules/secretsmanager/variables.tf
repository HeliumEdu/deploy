variable "environment" {
  description = "The environment"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "task_execution_role_arn" {
  description = "The Task execution role ARN"
  type        = string
}

# Below are the variable definitions for values to be stored in the Secrets Manager

variable "smtp_email_user" {
  type = string
}

variable "smtp_email_password" {
  type = string
}

variable "twilio_account_sid" {
  type = string
}

variable "twilio_auth_token" {
  type = string
}

variable "twilio_phone_number" {
  type = string
}

variable "s3_user_access_key_id" {
  type = string
}

variable "s3_user_secret_access_key" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "platform_secret" {
  type = string
}

variable "datadog_api_key" {
  type = string
}

variable "datadog_app_key" {
  type = string
}

variable "rollbar_access_token" {
  type = string
}