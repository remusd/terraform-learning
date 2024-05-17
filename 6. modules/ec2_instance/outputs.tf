
output "new_ec2_instance_id" {
    value = aws_instance.new_ec2_instance[*].id
    description = "get instance id"
}