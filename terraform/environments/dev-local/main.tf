module "ses" {
  source      = "../../modules/ses"
  environment = var.environment
}

module "twilio" {
  source      = "../../modules/phonenumbers"
  environment = var.environment
}