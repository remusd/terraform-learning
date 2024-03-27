resource "aws_launch_template" "main_ec2_launch_templ" {
  name_prefix   = "main_ec2_launch_templ"
  image_id      = "ami-0440d3b780d96b29d" # To note: AMI is specific for each region
  instance_type = "t2.micro"
  user_data     = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.private_subnet_1.id
    security_groups             = [aws_security_group.main_sg_for_ec2.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "my-instance" # Name for the EC2 instances
    }
  }
}

resource "aws_autoscaling_group" "main_asg" {
  # no of instances
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  # Connect to the target group
  target_group_arns = [aws_lb_target_group.main_alb_tg.arn]

  vpc_zone_identifier = [ # Creating EC2 instances in private subnet
    aws_subnet.private_subnet_1.id
  ]

  launch_template {
    id      = aws_launch_template.main_ec2_launch_templ.id
    version = "$Latest"
  }
}