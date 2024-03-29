resource "aws_launch_template" "wpdev_bastion_launch_templ" {
  name_prefix   = "wpdev_bastion_launch_templ"
  image_id      = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"
  key_name      = "ec2-key"
  user_data     = "${base64encode(data.template_file.user_data_bastion.rendered)}"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.wpdev_bastion_sg.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wpdev_bastion"
    }
  }

  depends_on = [ aws_efs_mount_target.efs_1a, aws_efs_mount_target.efs_1b ]
}


resource "aws_autoscaling_group" "wpdev_bastion_asg" {
  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = [
    aws_subnet.wpdev_pub_us_east_1a.id,
    aws_subnet.wpdev_pub_us_east_1b.id
  ]

  launch_template {
    id      = aws_launch_template.wpdev_bastion_launch_templ.id
    version = "$Latest"
  }
}