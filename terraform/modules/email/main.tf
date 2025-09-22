resource "aws_route53_record" "heliumedu_com_inbound_mx" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "${var.environment_prefix}heliumedu.com"
  type    = "MX"
  ttl     = "3600"
  records = ["10 mx1.privateemail.com", "10 mx2.privateemail.com"]
}

resource "aws_route53_record" "heliumedu_com_spf" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "${var.environment_prefix}heliumedu.com"
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:spf.privateemail.com ~all"]
}

resource "aws_route53_record" "heliumedu_com_dkim" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "default._domainkey.${var.environment_prefix}heliumedu.com"
  type    = "TXT"
  ttl     = "3600"
  records = [var.dkim_public_key]
}
