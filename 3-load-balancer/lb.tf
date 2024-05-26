resource "aws_lb" "alb" {
  name               = "strapi-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public_subnet1.id, data.aws_subnet.public_subnet2.id]
  security_groups    = [data.aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Content Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "alb_listener_https_rule" {
  listener_arn = aws_lb_listener.alb_listener_http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  # condition {
  #   host_header {
  #     values = [var.domain_name]
  #   }
  # }
}

# resource "aws_lb_listener" "alb_listener_http" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "alb_listener_https" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.certificate.arn

#   default_action {
#     type = "fixed-response"

#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Content Not Found"
#       status_code  = "404"
#     }
#   }
# }

# resource "aws_lb_listener_rule" "alb_listener_https_rule" {
#   listener_arn = aws_lb_listener.alb_listener_https.arn

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = [var.domain_name]
#     }
#   }
# }

resource "aws_lb_target_group" "alb_tg" {
  name        = "strapi-alb-tg"
  port        = 1337
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.vpc.id

  health_check {
    enabled             = true
    interval            = 30
    unhealthy_threshold = 10
  }
}
