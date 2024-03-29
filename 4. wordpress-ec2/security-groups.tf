resource "aws_security_group" "wpdev_alb_sg" {
  name   = "wpdev_alb_sg"
  vpc_id = aws_vpc.wpdev_vpc.id
  
  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "Allow https request from anywhere"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "wpdev_bastion_sg" {
  name   = "wpdev_bastion_sg"
  vpc_id = aws_vpc.wpdev_vpc.id

  ingress {
    description     = "Allow SSH requests from anywhere"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wpdev_efs_sg" {
  name   = "wpdev_efs_sg"
  vpc_id = aws_vpc.wpdev_vpc.id

  ingress {
    description     = "Allow NFS request from bastion host"
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.wpdev_bastion_sg.id]
  }

  ingress {
    description     = "Allow NFS request from app host"
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
    security_groups = [aws_security_group.wpdev_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wpdev_app_sg" {
  name   = "wpdev_app_sg"
  vpc_id = aws_vpc.wpdev_vpc.id

  ingress {
    description     = "Allow SSH request from bastion host"
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.wpdev_bastion_sg.id]
  }

  ingress {
    description     = "Allow http request from Load Balancer"
    protocol        = "tcp"
    from_port       = 80 # range of
    to_port         = 80 # port numbers
    security_groups = [aws_security_group.wpdev_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wpdev_db_sg" {
  name   = "wpdev_db_sg"
  vpc_id = aws_vpc.wpdev_vpc.id

  ingress {
    description     = "Allow DB requests from APP servers security group"
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.wpdev_app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}