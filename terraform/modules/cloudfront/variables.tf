variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_prefix" {
  description = "Prefix used for env in hostnames (empty string when `prod`)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "heliumedu_com_cert_arn" {
  description = "The ARN of the <env>heliumedu.com SSL certificate"
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket to host"
  type        = string
}
