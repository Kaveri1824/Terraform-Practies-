# ---------------------------------
# Existing VPC
# ---------------------------------
data "aws_vpc" "existing_vpc" {
  id = "vpc-0b02c98a8bb5403d6"
}

# ---------------------------------
# Existing Public Subnet
# ---------------------------------
data "aws_subnet" "existing_subnet" {
  id = "subnet-0f8f5a249b02186b1"
}

# ---------------------------------
# Existing Private Subnet
# ---------------------------------
data "aws_subnet" "existing_private_subnet" {
  id = "subnet-07bdc4e1d0e32255b"
}

# ---------------------------------
# Latest Amazon Linux 2023 AMI
# ---------------------------------
data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }
}

# ---------------------------------
# Security Group
# ---------------------------------
resource "aws_security_group" "web_sg" {

  name   = "Web-SG"
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    description = "SSH"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

# ---------------------------------
# EC2 Instance
# ---------------------------------
resource "aws_instance" "name" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = data.aws_subnet.existing_subnet.id

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = {
    Name = "Demo"
  }
}