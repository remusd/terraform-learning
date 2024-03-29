resource "aws_db_instance" "wpdev_db" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  username = "${var.wpdev_db_user}"
  password = "${var.wpdev_db_password}"
  
  skip_final_snapshot = true // required to destroy

  vpc_security_group_ids = [aws_security_group.wpdev_db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.wpdev_db_subnet_group.name
}

resource "aws_db_subnet_group" "wpdev_db_subnet_group" {
  name = "wpdev-db-subnet-group"
  subnet_ids = [aws_subnet.wpdev_db_us_east_1a.id, aws_subnet.wpdev_db_us_east_1b.id]

  tags = {
    Name = "Wordpress Dev DB Subnet Group"
  }
}