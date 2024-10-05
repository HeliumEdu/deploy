module "ses" {
  source      = "../../modules/ses"
  environment = var.environment
}

module "twilio" {
  source      = "../../modules/phonenumbers"
  environment = var.environment
  area_code   = var.area_code
}