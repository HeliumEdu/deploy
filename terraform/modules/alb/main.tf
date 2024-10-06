resource "aws_lb" "helium_prod" {
  name               = "helium-prod"
  internal           = false
  load_balancer_type = "application"
  security_groups = [var.security_group]
  subnets            = [for id in var.subnet_ids : id]

  enable_deletion_protection = true
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.helium_prod.arn
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
}

output "frontend_target_group" {
  value = aws_lb_target_group.frontend.arn
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
}

output "platform_target_group" {
  value = aws_lb_target_group.platform.arn
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.helium_prod.arn
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