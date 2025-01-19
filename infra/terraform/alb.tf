resource "aws_lb" "alb" {
  name               = "art-gallery-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.art_gallery_public_subnet.id, aws_subnet.art_gallery_public_subnet_2.id]

  enable_deletion_protection = false
}



resource "aws_lb_target_group" "alb_target_group_rds" {
  name     = "art-gallery-rds"
  port     = 8001
  protocol = "HTTP"
  vpc_id   = aws_vpc.art_gallery.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    path     = "/test_connection"
    interval = 30
    timeout  = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "alb_target_group_redis" {
  name     = "art-gallery-redis"
  port     = 8002
  protocol = "HTTP"
  vpc_id   = aws_vpc.art_gallery.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    path     = "/test_connection"
    interval = 30
    timeout  = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "alb_target_group_frontend" {
  name     = "art-gallery-frontend"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.art_gallery.id
  target_type = "ip"

  health_check {
    protocol = "HTTP"
    path     = "/"
    interval = 30
    timeout  = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No services available"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 30

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_frontend.arn
  }
}

resource "aws_lb_listener_rule" "rds" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/rds/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_rds.arn
  }
}

resource "aws_lb_listener_rule" "redis" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/redis/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_redis.arn
  }
}