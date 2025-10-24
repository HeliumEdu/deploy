data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "route53" {
  source = "../../modules/route53"

  environment        = var.environment
  environment_prefix = var.environment_prefix
  parent_com_zone_id = var.prod_com_zone_id
  parent_dev_zone_id = var.prod_dev_zone_id
}

module "certificatemanager" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/certificatemanager"

  providers = {
    aws                 = aws
    aws.force_us_east_1 = aws.force_us_east_1
  }

  environment_prefix            = var.environment_prefix
  route53_heliumedu_com_zone_id = module.route53.heliumedu_com_zone_id
  route53_heliumedu_dev_zone_id = module.route53.heliumedu_dev_zone_id
  aws_region                    = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  environment = var.environment
  aws_region  = var.aws_region
  region_azs  = var.region_azs
}

module "alb" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/alb"

  environment                   = var.environment
  environment_prefix            = var.environment_prefix
  route53_heliumedu_com_zone_id = module.route53.heliumedu_com_zone_id
  security_group                = module.vpc.http_s_sg_id
  subnet_ids                    = module.vpc.subnet_ids
  helium_vpc_id                 = module.vpc.vpc_id
  heliumedu_com_cert_arn        = module.certificatemanager[0].heliumedu_com_cert_arn
}

module "rds" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/rds"

  environment   = var.environment
  subnet_ids    = module.vpc.subnet_ids
  mysql_sg      = module.vpc.mysql_sg
  multi_az      = var.db_multi_az
  instance_size = var.db_instance_size
}

module "ecs" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/ecs"

  helium_version                   = var.helium_version
  default_arch                     = var.default_arch
  platform_host_count              = var.platform_host_count
  platform_resource_repository_uri = var.platform_resource_repository_uri
  platform_api_repository_uri      = var.platform_api_repository_uri
  platform_worker_repository_uri   = var.platform_worker_repository_uri
  environment                      = var.environment
  environment_prefix               = var.environment_prefix
  aws_account_id                   = local.aws_account_id
  aws_region                       = var.aws_region
  datadog_api_key                  = var.DD_API_KEY
  http_platform                    = module.vpc.http_sg_platform
  platform_target_group            = module.alb[0].platform_target_group
  subnet_ids                       = module.vpc.subnet_ids
}

module "elasticache" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/elasticache"

  environment     = var.environment
  subnet_ids      = module.vpc.subnet_ids
  elasticache_sg  = module.vpc.elasticache_sg
  num_cache_nodes = var.num_cache_nodes
  instance_size   = var.cache_instance_size
}

module "email" {
  source = "../../modules/email"

  environment                   = var.environment
  route53_heliumedu_com_zone_id = module.route53.heliumedu_com_zone_id
}

module "s3" {
  source = "../../modules/s3"

  aws_account_id = local.aws_account_id
  environment    = var.environment
}

module "cloudfront" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/cloudfront"

  environment                   = var.environment
  environment_prefix            = var.environment_prefix
  s3_bucket                     = module.s3.heliumedu_s3_frontend_bucket_name
  s3_website_endpoint           = module.s3.heliumedu_s3_website_endpoint
  heliumedu_com_cert_arn        = module.certificatemanager[0].heliumedu_com_cert_arn
  route53_heliumedu_com_zone_id = module.route53.heliumedu_com_zone_id
}

module "ses" {
  source = "../../modules/ses"

  environment                   = var.environment
  environment_prefix            = var.environment_prefix
  aws_region                    = var.aws_region
  heliumedu_s3_bucket_name      = module.s3.heliumedu_s3_ci_bucket_name
  route53_heliumedu_com_zone_id = module.route53.heliumedu_com_zone_id
  route53_heliumedu_dev_zone_id = module.route53.heliumedu_dev_zone_id
}

module "secretsmanager" {
  source = "../../modules/secretsmanager"

  environment                               = var.environment
  aws_account_id                            = local.aws_account_id
  aws_region                                = var.aws_region
  task_execution_role_arn                   = module.ecs[0].task_execution_role_arn
  datadog_api_key                           = var.DD_API_KEY
  redis_host                                = module.elasticache[0].elasticache_host
  db_host                                   = module.rds[0].db_host
  db_user                                   = module.rds[0].db_username
  db_password                               = module.rds[0].db_password
  platform_rollbar_server_item_access_token = var.PLATFORM_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN
  s3_user_access_key_id                     = module.s3.s3_access_key_id
  s3_user_secret_access_key                 = module.s3.s3_access_key_secret
  smtp_email_user                           = module.ses.smtp_username
  smtp_email_password                       = module.ses.smtp_password
  twilio_account_sid                        = var.TWILIO_ACCOUNT_SID
  twilio_auth_token                         = var.TWILIO_AUTH_TOKEN
  twilio_phone_number                       = module.twilio[0].helium_phone_number
  firebase_project_id                       = var.FIREBASE_PROJECT_ID
  firebase_private_key_id                   = var.FIREBASE_PRIVATE_KEY_ID
  firebase_private_key                      = var.FIREBASE_PRIVATE_KEY
  firebase_client_email                     = var.FIREBASE_CLIENT_EMAIL
  firebase_client_id                        = var.FIREBASE_CLIENT_ID
  firebase_client_x509_cert_url             = var.FIREBASE_CLIENT_X509_CERT_URL
}

module "twilio" {
  count = var.dev_env_enabled ? 1 : 0

  source = "../../modules/twilio"

  environment              = var.environment
  helium_area_code         = var.helium_area_code
  ci_area_code             = var.ci_area_code
  helium_twiml_handler_url = var.HELIUM_TWIML_HANDLER_URL
  ci_twiml_handler_url     = var.CI_TWIML_HANDLER_URL
}
