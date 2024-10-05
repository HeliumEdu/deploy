variable "environment" {
  description = "The environment"
  type        = string
}

variable "environment_prefix" {
  description = "Env when used as a prefix for things like hostname (empty when prod)"
  type        = string
}