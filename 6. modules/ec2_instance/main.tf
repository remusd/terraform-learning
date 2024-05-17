
resource "aws_instance" "new_ec2_instance" {
    count = var.ec2_instance_count
    ami = var.ec2_ami_id
    instance_type = var.ec2_instance_type

    tags = {
      name = "${var.ec2_instance_prefix}-${var.ec2_instance_name}-${count.index}"
    }
}