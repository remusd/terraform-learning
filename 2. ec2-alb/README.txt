EC2 scenario

VPC with 1 private and 2 public subnets
Internet Gateway in VPC
NAT Gateway in one public subnet
Application Load Balancer on the two public subnets
ALB listener balances requests on port 80/HTTP to EC2 target group
ASG to scale (2) EC2 instances in private subnet using launch template
Launch template has user_data that spins up simple Apache web server

