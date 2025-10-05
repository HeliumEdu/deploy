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
    host_name = "https://heliumedu.freshdesk.com"
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

resource "aws_cloudfront_distribution" "support_heliumedu_com" {
  enabled             = true
  aliases             = ["support.${var.environment_prefix}heliumedu.com"]
  comment             = "support.${var.environment_prefix}heliumedu.com"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket_website_configuration.support_redirect_bucket.website_endpoint
    origin_id   = "${aws_s3_bucket.support_redirect_bucket.bucket}-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.support_redirect_bucket.bucket}-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.heliumedu_com_cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "support_heliumedu_com" {
  zone_id = aws_route53_zone.heliumedu_com_zone.zone_id
  name    = "support.${var.environment_prefix}heliumedu.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.support_heliumedu_com.domain_name
    zone_id                = aws_cloudfront_distribution.support_heliumedu_com.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "app_redirect_bucket" {
  bucket = "app.${var.environment_prefix}heliumedu.com-redirect"
}

resource "aws_s3_bucket_website_configuration" "app_redirect_bucket" {
  bucket = aws_s3_bucket.app_redirect_bucket.bucket

  redirect_all_requests_to {
    host_name = "www.${var.environment_prefix}heliumedu.com/app"
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

resource "aws_cloudfront_distribution" "app_heliumedu_com" {
  enabled             = true
  aliases             = ["app.${var.environment_prefix}heliumedu.com"]
  comment             = "app.${var.environment_prefix}heliumedu.com"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket_website_configuration.app_redirect_bucket.website_endpoint
    origin_id   = "${aws_s3_bucket.app_redirect_bucket.bucket}-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.app_redirect_bucket.bucket}-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.heliumedu_com_cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_route53_record" "app_heliumedu_com" {
  zone_id = aws_route53_zone.heliumedu_com_zone.zone_id
  name    = "app.${var.environment_prefix}heliumedu.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.app_heliumedu_com.domain_name
    zone_id                = aws_cloudfront_distribution.app_heliumedu_com.hosted_zone_id
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
