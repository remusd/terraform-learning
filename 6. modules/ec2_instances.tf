
module "my_ec2_web" {
    source = "./ec2_instance"

    ec2_instance_type = var.ec2_instance_type
    ec2_instance_prefix = var.ec2_instance_prefix
    ec2_instance_name = var.ec2_instance_name
    ec2_ami_id = var.ec2_ami_id
    ec2_instance_count = var.ec2_instance_count
}

output "instance_id" {
    value = module.my_ec2_web.new_ec2_instance_id
}