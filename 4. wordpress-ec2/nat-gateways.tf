# Elastic IPs for NAT gateways
resource "aws_eip" "wpdev_nat_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "wpdev_nat_eip_1a"
  }
}

resource "aws_eip" "wpdev_nat_eip_1b" {
  domain = "vpc"
  tags = {
    Name = "wpdev_nat_eip_1b"
  }
}


# NAT gateway for the two WEP/APP private subnets
# NAT gateways must be placed in public subnets
resource "aws_nat_gateway" "wpdev_nat_1a" {
  allocation_id = aws_eip.wpdev_nat_eip_1a.id
  subnet_id     = aws_subnet.wpdev_pub_us_east_1a.id
  tags = {
    Name = "NAT gateway for APP private subnet in zone 1a"
  }
  depends_on = [aws_internet_gateway.wpdev_igw]
}

resource "aws_nat_gateway" "wpdev_nat_1b" {
  allocation_id = aws_eip.wpdev_nat_eip_1b.id
  subnet_id     = aws_subnet.wpdev_pub_us_east_1b.id
  tags = {
    Name = "NAT gateway for APP private subnet in zone 1b"
  }
  depends_on = [aws_internet_gateway.wpdev_igw]
}


# Route table for connecting to NAT gw
resource "aws_route_table" "wpdev_nat_rt1a" {
  vpc_id = aws_vpc.wpdev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wpdev_nat_1a.id
  }
}

resource "aws_route_table" "wpdev_nat_rt1b" {
  vpc_id = aws_vpc.wpdev_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.wpdev_nat_1b.id
  }
}


# Associate the route table with the APP private subnet
resource "aws_route_table_association" "wpdev_nat_rta1a" {
  subnet_id      = aws_subnet.wpdev_app_us_east_1a.id
  route_table_id = aws_route_table.wpdev_nat_rt1a.id
}

resource "aws_route_table_association" "wpdev_nat_rta1b" {
  subnet_id      = aws_subnet.wpdev_app_us_east_1b.id
  route_table_id = aws_route_table.wpdev_nat_rt1b.id
}