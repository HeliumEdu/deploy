variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_prefix" {
  description = "Env when used as a prefix for things like hostname (empty when prod)"
  type        = string
}

variable "route53_heliumedu_com_zone_id" {
  description = "The Route 53 Zone ID"
  type = string
}

variable "route53_heliumedu_dev_zone_id" {
  description = "The Route 53 Zone ID"
  type = string
}