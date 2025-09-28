resource "aws_lb" "helium" {
  name               = "helium-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups = [var.security_group]
  subnets            = [for id in var.subnet_ids : id]

  enable_deletion_protection = true
}

resource "aws_route53_record" "heliumedu_com_lb_cname" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "${var.environment_prefix}heliumedu.com"
  type    = "A"

  alias {
    name                   = aws_lb.helium.dns_name
    zone_id                = aws_lb.helium.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_heliumedu_com_lb_cname" {
  zone_id = var.route53_heliumedu_com_zone_id
  name    = "api.${var.environment_prefix}heliumedu.com"
  type    = "CNAME"
  ttl     = "86400"
  records = [aws_lb.helium.dns_name]
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.helium.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "helium-frontend-http"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.helium_vpc_id

  health_check {
    path = "/health.json"
  }

  depends_on = [aws_lb.helium]
}

resource "aws_lb_target_group" "platform" {
  name        = "helium-platform-http"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.helium_vpc_id

  health_check {
    path = "/status/"
  }

  depends_on = [aws_lb.helium]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.helium.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.heliumedu_com_cert_arn

  default_action {
    type  = "fixed-response"
    order = 3

    fixed_response {
      content_type = "text/plain"
      message_body = "Unknown host header."
      status_code  = "400"
    }
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 1

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["${var.environment_prefix}heliumedu.com", "www.${var.environment_prefix}heliumedu.com"]
    }
  }
}

resource "aws_lb_listener_rule" "platform" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 2

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.platform.arn
  }

  condition {
    host_header {
      values = ["api.${var.environment_prefix}heliumedu.com"]
    }
  }
}