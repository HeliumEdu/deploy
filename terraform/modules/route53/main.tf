resource "aws_route53_zone" "heliumedu_com_zone" {
  name = "${var.environment_prefix}heliumedu.com"
}

resource "aws_route53_zone" "heliumedu_dev_zone" {
  name = "${var.environment_prefix}heliumedu.dev"
}

resource "aws_s3_bucket" "support_redirect_bucket" {
  bucket = "support.${var.environment_prefix}heliumedu.com-redirect"
}

resource "aws_s3_bucket_website_configuration" "support_redirect_bucket" {
  bucket = aws_s3_bucket.support_redirect_bucket.bucket

  redirect_all_requests_to {
    host_name = "www.${var.environment_prefix}heliumedu.com/support"
    protocol  = "https"
  }
}

data "aws_iam_policy_document" "heliumedu_support_redirect_allow_http_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::support.${var.environment_prefix}heliumedu.com-redirect/**",
    ]

    actions = [
      "s3:GetObject"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "heliumedu_support_redirect_allow_public" {
  bucket = aws_s3_bucket.support_redirect_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "heliumedu_support_redirect_allow_http_access" {
  bucket = aws_s3_bucket.support_redirect_bucket.id
  policy = data.aws_iam_policy_document.heliumedu_support_redirect_allow_http_access.json

  depends_on = [aws_s3_bucket_public_access_block.heliumedu_support_redirect_allow_public]
}

resource "aws_route53_record" "support_heliumedu_com" {
  zone_id = aws_route53_zone.heliumedu_com_zone
  name    = "support.${var.environment_prefix}heliumedu.com-redirect"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.support_redirect_bucket.website_endpoint
    zone_id                = aws_s3_bucket.support_redirect_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "app_redirect_bucket" {
  bucket = "app.${var.environment_prefix}heliumedu.com-redirect"
}

resource "aws_s3_bucket_website_configuration" "app_redirect_bucket" {
  bucket = aws_s3_bucket.app_redirect_bucket.bucket

  redirect_all_requests_to {
    host_name = "www.${var.environment_prefix}heliumedu.com/planner/calendar"
    protocol  = "https"
  }
}

data "aws_iam_policy_document" "heliumedu_app_redirect_allow_http_access" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::app.${var.environment_prefix}heliumedu.com-redirect/**",
    ]

    actions = [
      "s3:GetObject"
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "heliumedu_app_redirect_allow_public" {
  bucket = aws_s3_bucket.app_redirect_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "heliumedu_app_redirect_allow_http_access" {
  bucket = aws_s3_bucket.app_redirect_bucket.id
  policy = data.aws_iam_policy_document.heliumedu_app_redirect_allow_http_access.json

  depends_on = [aws_s3_bucket_public_access_block.heliumedu_app_redirect_allow_public]
}

resource "aws_route53_record" "app_heliumedu_com" {
  zone_id = aws_route53_zone.heliumedu_com_zone
  name    = "app.${var.environment_prefix}heliumedu.com-redirect"
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.app_redirect_bucket.website_endpoint
    zone_id                = aws_s3_bucket.app_redirect_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

// Records only created once, for production

resource "aws_route53_record" "blog_heliumedu_com_cname" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = aws_route53_zone.heliumedu_com_zone.id
  name    = "blog.heliumedu.com"
  type    = "CNAME"
  ttl     = "86400"
  records = ["domains.tumblr.com"]
}

resource "aws_route53_record" "heliumedu_com_gh_txt" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = aws_route53_zone.heliumedu_com_zone.id
  name    = "_gh-HeliumEdu-o.heliumedu.com"
  type    = "TXT"
  ttl     = "3600"
  records = ["b73c3b72a1"]
}

resource "aws_route53_record" "status_heliumedu_com_cname" {
  count = var.environment == "prod" ? 1 : 0

  zone_id = aws_route53_zone.heliumedu_com_zone.id
  name    = "status.heliumedu.com"
  type    = "CNAME"
  ttl     = "86400"
  records = ["statuspage.betteruptime.com"]
}
