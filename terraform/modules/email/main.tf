// Records only created once, for production

resource "aws_route53_record" "heliumedu_com_inbound_mx" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = var.route53_heliumedu_com_zone_name
  type    = "MX"
  ttl     = "3600"
  records = ["10 mx1.privateemail.com", "10 mx2.privateemail.com"]
}

resource "aws_route53_record" "heliumedu_com_spf" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = var.route53_heliumedu_com_zone_name
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:spf.privateemail.com include:_spf.firebasemail.com ~all"]
}

resource "aws_route53_record" "heliumedu_com_dkim" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = "default._domainkey.${var.route53_heliumedu_com_zone_name}"
  type    = "TXT"
  ttl     = "3600"
  records = [
    join("\"\"", [
      substr(var.dkim_public_key, 0, 255),
      substr(var.dkim_public_key, 255, 255),
    ])
  ]
}

// Firebase domain verification
resource "aws_route53_record" "heliumedu_com_firebase_verification" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = var.route53_heliumedu_com_zone_name
  type    = "TXT"
  ttl     = "3600"
  records = ["firebase=helium-edu"]
}

// Firebase DKIM records for custom email domain
resource "aws_route53_record" "heliumedu_com_firebase_dkim1" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = "firebase1._domainkey.${var.route53_heliumedu_com_zone_name}"
  type    = "CNAME"
  ttl     = "3600"
  records = ["mail-heliumedu-com.dkim1._domainkey.firebasemail.com."]
}

resource "aws_route53_record" "heliumedu_com_firebase_dkim2" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = var.route53_heliumedu_com_zone_id
  name    = "firebase2._domainkey.${var.route53_heliumedu_com_zone_name}"
  type    = "CNAME"
  ttl     = "3600"
  records = ["mail-heliumedu-com.dkim2._domainkey.firebasemail.com."]
}
