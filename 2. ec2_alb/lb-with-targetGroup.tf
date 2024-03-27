resource "aws_lb" "main_lb" {
  name               = "main-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main_sg_for_elb.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  depends_on         = [aws_internet_gateway.main_gw]
}

resource "aws_lb_target_group" "main_alb_tg" {
  name     = "my-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
}

resource "aws_lb_listener" "main_front_end" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_alb_tg.arn
  }
}