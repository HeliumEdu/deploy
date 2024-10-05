###########################################################################
# Once provisioned, manually create the following Twiml Bins (the twilio
# Terraform provider does not support provisioning Twiml Bins):
#
# Friendly Name: Helium Auto Response
# <?xml version="1.0" encoding="UTF-8"?>
# <Response>
#   <Message><Body>This number is only for sending notifications and is not monitored.</Body></Message>
# </Response>
#
# Friendly Name: CI Empty Ack
# <?xml version="1.0" encoding="UTF-8"?>
# <Response></Response>
#
# For the actions under "A message comes in", tie "Helium Auto Response"
# to the "Helium Edu" and "CI Emtpy Ack" to the "CI Test Number".
###########################################################################

resource "twilio_api_accounts_incoming_phone_numbers" "helium_phone_number" {
  area_code     = var.area_code
  friendly_name = "Helium Edu (${var.environment})"
  sms_url       = ""
  voice_url     = ""
}

output "helium_phone_number" {
  value = twilio_api_accounts_incoming_phone_numbers.helium_phone_number
}

resource "twilio_api_accounts_incoming_phone_numbers" "ci_phone_number" {
  area_code     = var.area_code
  friendly_name = "CI Test Number (${var.environment})"
  sms_url       = ""
  voice_url     = ""
}

output "ci_phone_number" {
  value = twilio_api_accounts_incoming_phone_numbers.ci_phone_number
}
