resource "aws_efs_file_system" "wpdev_efs" {
    creation_token = "wpdev_efs"
    performance_mode = "generalPurpose"
    throughput_mode = "bursting"
    encrypted = "true"
    tags = {
        Name = "wpdev_efs"
    }
}

resource "aws_efs_mount_target" "efs_1a" {
  file_system_id  = aws_efs_file_system.wpdev_efs.id
  subnet_id       = aws_subnet.wpdev_app_us_east_1a.id
  security_groups = [aws_security_group.wpdev_efs_sg.id]
}

resource "aws_efs_mount_target" "efs_1b" {
  file_system_id  = aws_efs_file_system.wpdev_efs.id
  subnet_id       = aws_subnet.wpdev_app_us_east_1b.id
  security_groups = [aws_security_group.wpdev_efs_sg.id]
}