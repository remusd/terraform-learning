resource "aws_instance" "test_ec1" {
  ami                     = "ami-0440d3b780d96b29d"
  instance_type           = "t2.micro"
  subnet_id               = aws_subnet.testnet-private-2.id
  iam_instance_profile    = aws_iam_instance_profile.test_ec2_profile.name
  vpc_security_group_ids  = [aws_security_group.test_sg.id]

  tags = {
    Name = "test-ec2-1"
  }
}

resource "aws_security_group" "test_sg" {
    name = "allow_access"
    description = "allow outbound traffic"
    vpc_id = aws_vpc.main.id
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Enable access to the internet"
    }
    
    tags = {
        Name = "test-ec2-sg"
    }
}

resource "aws_iam_role" "test_role" {
  name = "test-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
              Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
    role = aws_iam_role.test_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "test_ec2_profile" {
    name = "test-ec2-profile"
    role = aws_iam_role.test_role.name
}