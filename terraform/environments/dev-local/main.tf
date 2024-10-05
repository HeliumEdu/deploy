module "route53" {
  source             = "../../modules/route53"
  environment        = var.environment
  environment_prefix = var.environment_prefix
}

module "certificatemanager" {
  source             = "../../modules/certificatemanager"
  environment        = var.environment
  environment_prefix = var.environment_prefix
}

module "ses" {
  source             = "../../modules/ses"
  environment        = var.environment
  environment_prefix = var.environment_prefix
}

module "twilio" {
  source                   = "../../modules/twilio"
  environment              = var.environment
  area_code                = var.area_code
  helium_twiml_handler_url = var.helium_twiml_handler_url
  ci_twiml_handler_url     = var.ci_twiml_handler_url
}