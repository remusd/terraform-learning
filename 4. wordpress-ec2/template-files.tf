
data "template_file" "user_data_bastion" {
  template = "${file("${path.module}/user_data/user_data_bastion.tpl")}"
  vars = {
    efs_mount_target = "${aws_efs_file_system.wpdev_efs.dns_name}"
  }
}

data "template_file" "user_data_wp" {
  template = "${file("${path.module}/user_data/user_data_wp.tpl")}"
  vars = {
    efs_mount_target = "${aws_efs_file_system.wpdev_efs.dns_name}"
  }
}