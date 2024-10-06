variable "environment" {
  description = "The environment"
  type        = string
}

variable "username" {
  description = "The DB username"
}

variable "password" {
  description = "The DB password"
}

variable "mysql_sg" {
  description = "The MySQL security group"
}