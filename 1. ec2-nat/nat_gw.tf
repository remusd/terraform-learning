# Public NAT. 
resource "aws_nat_gateway" "test_nat" {
  allocation_id = aws_eip.test_eip.id
  subnet_id     = aws_subnet.testnet-public-1.id

  tags = {
    Name = "test gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.test_internet_gw]
}

# Elastic IP for NAT gateway
resource "aws_eip" "test_eip" {
  depends_on = [aws_internet_gateway.test_internet_gw]
  domain = "vpc"
  tags = {
    Name = "test_EIP_for_NAT"
  }
}

resource "aws_route_table" "test_rt1" {
  vpc_id = aws_vpc.main.id

  # Route to internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.test_nat.id
  }
}

resource "aws_route_table_association" "test_rta1" {
  subnet_id      = aws_subnet.testnet-private-2.id
  route_table_id = aws_route_table.test_rt1.id
}