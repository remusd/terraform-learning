resource "aws_lb" "wpdev_alb" {
  name               = "wpdev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.wpdev_alb_sg.id]
  subnets            = [aws_subnet.wpdev_pub_us_east_1a.id, aws_subnet.wpdev_pub_us_east_1b.id]
  depends_on         = [aws_internet_gateway.wpdev_igw]
}

resource "aws_lb_target_group" "wpdev_alb_tg" {
  name     = "wpdev-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.wpdev_vpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "wpdev_alb_listener" {
  load_balancer_arn = aws_lb.wpdev_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wpdev_alb_tg.arn
  }
}