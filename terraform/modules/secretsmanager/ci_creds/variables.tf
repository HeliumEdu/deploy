variable "environment" {
  description = "The environment"
  type        = string
}

# Below are the variable definitions for values to be stored in the Secrets Manager

variable "smtp_email_user" {
  type = string
}

variable "smtp_email_password" {
  type = string
}

variable "s3_user_access_key_id" {
  type = string
}

variable "s3_user_secret_access_key" {
  type = string
}