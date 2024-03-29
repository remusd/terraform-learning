# VPC
resource "aws_vpc" "wpdev_vpc" {
  cidr_block = "20.0.0.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "wpdev_vpc"
  }
}


# Creating two public subnets for the ALB and NAT gateways
resource "aws_subnet" "wpdev_pub_us_east_1a" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "wpdev_pub_us_east_1a"
  }
}

resource "aws_subnet" "wpdev_pub_us_east_1b" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.16/28"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "wpdev_pub_us_east_1b"
  }
}


# Creating two private subnets for the WEB/APP servers
resource "aws_subnet" "wpdev_app_us_east_1a" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.32/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "wpdev_app_us_east_1a"
  }
}

resource "aws_subnet" "wpdev_app_us_east_1b" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.48/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "wpdev_app_us_east_1b"
  }
}


# Creating two private subnets for the RDS instances
resource "aws_subnet" "wpdev_db_us_east_1a" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.64/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "wpdev_db_us_east_1a"
  }
}

resource "aws_subnet" "wpdev_db_us_east_1b" {
  vpc_id                  = aws_vpc.wpdev_vpc.id
  cidr_block              = "20.0.0.80/28"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "wpdev_db_us_east_1b"
  }
}