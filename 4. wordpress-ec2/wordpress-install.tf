data "aws_instances" "bastion_instances" {
  filter {
    name   = "tag:Name"
    values = ["wpdev_bastion"]
  }

  instance_state_names = ["running"]

  depends_on = [ aws_autoscaling_group.wpdev_bastion_asg ]
}

data "aws_instances" "app_instances" {
  filter {
    name   = "tag:Name"
    values = ["wpdev_app"]
  }

  instance_state_names = ["running"]

  depends_on = [ aws_autoscaling_group.wpdev_app_asg ]
}

resource "null_resource" "wordpress_install" {
  connection {
    host = data.aws_instances.bastion_instances.public_ips[1]
    type = "ssh"
    user = "ec2-user"
    private_key = "${file(var.ssh_key_private)}"
    timeout = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo wget https://wordpress.org/latest.zip",
      "sudo unzip latest.zip",
      "cloud-init status --wait > /dev/null",
      "sudo mount -a",
      "sudo mv wordpress/* /mnt",
      "sudo chown -R 48:48 /mnt/*" // should match Apache user id
    ]
  }
}