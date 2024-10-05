module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}

# TODO: add certificate manager

# TODO: add load balancer and target groups

# TODO: add secrets manager

# TODO: add RDS

# TODO: add Elasticache

# TODO: add ECS clusters

# TODO: add S3 buckets

module "ses" {
  source      = "../../modules/ses"
  environment = var.environment
}

module "twilio" {
  source      = "../../modules/phonenumbers"
  environment = var.environment
}