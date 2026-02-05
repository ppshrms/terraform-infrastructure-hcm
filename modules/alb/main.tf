# ALB Module - Application Load Balancers

# Frontend ALB
resource "aws_lb" "frontend" {
  name               = "${var.customer_name}-${var.environment}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend-alb"
    }
  )
}

# Frontend Target Group
resource "aws_lb_target_group" "frontend" {
  name     = "${var.customer_name}-${var.environment}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend-tg"
    }
  )
}

# Frontend ALB Listener - HTTPS (only created if certificate is provided)
resource "aws_lb_listener" "frontend_https" {
  count = var.certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.frontend.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend-https-listener"
    }
  )
}

# Frontend ALB Listener - HTTP
# Phase 1: Forward directly to target group
# Phase 2: Redirect rule will be added via separate resource
resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend-http-listener"
    }
  )
}

# Backend ALB
resource "aws_lb" "backend" {
  name               = "${var.customer_name}-${var.environment}-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-backend-alb"
    }
  )
}

# Backend Target Group
resource "aws_lb_target_group" "backend" {
  name     = "${var.customer_name}-${var.environment}-backend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }

  deregistration_delay = 30

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-backend-tg"
    }
  )
}

# Backend ALB Listener - HTTPS (only created if certificate is provided)
resource "aws_lb_listener" "backend_https" {
  count = var.certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.backend.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-backend-https-listener"
    }
  )
}

# Backend ALB Listener - HTTP
# Phase 1: Forward directly to target group
# Phase 2: Redirect rule will be added via separate resource
resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-backend-http-listener"
    }
  )
}

