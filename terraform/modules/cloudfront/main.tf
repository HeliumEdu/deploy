resource "aws_cloudfront_function" "rewrites" {
  name    = "rewrites"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/rewrites.js")
}

resource "aws_cloudfront_distribution" "heliumedu_frontend" {
  enabled     = true
  aliases     = ["www.${var.environment_prefix}heliumedu.com"]
  comment     = "www.${var.environment_prefix}heliumedu.com"
  price_class = "PriceClass_100"

  origin {
    origin_id   = "${var.s3_bucket}-origin"
    domain_name = var.s3_website_endpoint
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  default_cache_behavior {
    target_origin_id = "${var.s3_bucket}-origin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 3600
    min_ttl                = 300
    max_ttl                = 86400

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrites.arn
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }

  custom_error_response {
    error_code         = 500
    response_code      = 500
    response_page_path = "/500.html"
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

resource "aws_route53_record" "www_heliumedu_com" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "www.${var.environment_prefix}heliumedu.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.heliumedu_frontend.domain_name
    zone_id                = aws_cloudfront_distribution.heliumedu_frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "heliumedu_frontend_non_www" {
  bucket = "heliumedu.${var.environment}.frontend.non-www-redirect"
}

resource "aws_s3_bucket_website_configuration" "heliumedu_frontend_non_www_config" {
  bucket = aws_s3_bucket.heliumedu_frontend_non_www.bucket

  redirect_all_requests_to {
    host_name = "www.${var.environment_prefix}heliumedu.com"
    protocol  = "https"
  }
}

resource "aws_cloudfront_distribution" "heliumedu_frontend_non_www" {
  enabled     = true
  aliases     = ["${var.environment_prefix}heliumedu.com"]
  comment     = "${var.environment_prefix}heliumedu.com"
  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket_website_configuration.heliumedu_frontend_non_www_config.website_endpoint
    origin_id   = "${aws_s3_bucket.heliumedu_frontend_non_www.bucket}-origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "${aws_s3_bucket.heliumedu_frontend_non_www.bucket}-origin"
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

resource "aws_route53_record" "heliumedu_com" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "${var.environment_prefix}heliumedu.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.heliumedu_frontend_non_www.domain_name
    zone_id                = aws_cloudfront_distribution.heliumedu_frontend_non_www.hosted_zone_id
    evaluate_target_health = false
  }
}
