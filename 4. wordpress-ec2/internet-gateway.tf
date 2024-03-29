# Internet Gateway
resource "aws_internet_gateway" "wpdev_igw" {
  vpc_id = aws_vpc.wpdev_vpc.id
}


# Route table for public subnet _ connecting to Internet gateway
resource "aws_route_table" "wpdev_pub_rt" {
  vpc_id = aws_vpc.wpdev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wpdev_igw.id
  }
}


# Associate the route table with the two public subnets
resource "aws_route_table_association" "wpdev_rta1" {
  subnet_id      = aws_subnet.wpdev_pub_us_east_1a.id
  route_table_id = aws_route_table.wpdev_pub_rt.id
}

resource "aws_route_table_association" "wpdev_rta2" {
  subnet_id      = aws_subnet.wpdev_pub_us_east_1b.id
  route_table_id = aws_route_table.wpdev_pub_rt.id
}