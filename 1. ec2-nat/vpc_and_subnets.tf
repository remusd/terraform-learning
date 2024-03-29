resource "aws_vpc" "main" {
  cidr_block = "20.0.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "testnet-public-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "testnet-public-1"
  }
}

resource "aws_subnet" "testnet-public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "testnet-public-2"
  }
}

resource "aws_subnet" "testnet-private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.3.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "testnet-private-1"
  }
}

resource "aws_subnet" "testnet-private-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "20.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "testnet-private-2"
  }
}