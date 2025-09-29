locals {
  s3_origin_id   = "${var.s3_bucket}-origin"
  s3_domain_name = "${var.s3_bucket}.s3-website-${var.aws_region}.amazonaws.com"
}

resource "aws_cloudfront_function" "rewrites" {
  name    = "rewrites"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/rewrites.js")
}

resource "aws_cloudfront_distribution" "heliumedu_frontend" {
  enabled = true

  origin {
    origin_id   = local.s3_origin_id
    domain_name = local.s3_domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    target_origin_id = local.s3_origin_id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrites.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = ["www.${var.environment_prefix}heliumedu.com", "${var.environment_prefix}heliumedu.com"]

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.heliumedu_com_cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  price_class = "PriceClass_100"
}

resource "aws_s3_bucket" "heliumedu_frontend_non_www_redirect" {
  bucket = "heliumedu.${var.environment}.frontend.non_wwww_redirect"
}

resource "aws_s3_bucket_website_configuration" "heliumedu_frontend_non_www_redirect_config" {
  bucket = aws_s3_bucket.heliumedu_frontend_non_www_redirect.bucket

  redirect_all_requests_to {
    host_name = "www.${var.environment_prefix}heliumedu.com"
    protocol  = "https"
  }
}
