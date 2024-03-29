# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/23"
  tags = {
    Name = "my-vpc"
  }
}

# Creating 1st public subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/27"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

# Creating 2nd public subnet
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.32/27"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
}

# Creating 1st private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/27"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
}