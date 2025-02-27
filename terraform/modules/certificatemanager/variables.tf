variable "environment_prefix" {
  description = "Prefix used for env in hostnames (empty string when `prod`)"
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