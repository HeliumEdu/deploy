variable "environment" {
  description = "The environment"
  default     = "dev-local"
}

variable "aws_region" {
  description = "The AWS region"
  default = "us-east-1"
}

variable "area_code" {
    description = "The area code for the phone number"
    default     = "650"
}