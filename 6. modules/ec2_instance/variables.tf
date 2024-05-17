
variable "ec2_instance_type" {
    type = string
    default = "t2.micro"
}

variable "ec2_instance_prefix" {
    type = string
}

variable "ec2_instance_name" {
    type = string
}

variable "ec2_ami_id" {
    type = string
    default = "ami-0bb84b8ffd87024d8"
}

variable "ec2_instance_count" {
    type = number
    default = 1
}