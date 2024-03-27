# Internet Gateway.
resource "aws_internet_gateway" "test_internet_gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "test_rt2" {
  vpc_id = aws_vpc.main.id

  # Route to internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_internet_gw.id
  }
}

resource "aws_route_table_association" "test_rta2" {
  subnet_id      = aws_subnet.testnet-public-2.id
  route_table_id = aws_route_table.test_rt2.id
}