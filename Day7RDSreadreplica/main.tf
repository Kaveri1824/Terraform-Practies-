# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Data"
  }
}

# ---------------------------
# Public Subnet
# ---------------------------
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.name.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# ---------------------------
# Private Subnet 1
# ---------------------------
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 1"
  }
}

# ---------------------------
# Private Subnet 2
# ---------------------------
resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 2"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "My-IG"
  }
}

# ---------------------------
# Route Table
# ---------------------------
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# ---------------------------
# Route Table Association
# ---------------------------
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.name.id
}

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "rds_sg" {
  name   = "RDS_SG"
  vpc_id = aws_vpc.name.id

  # MySQL
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# DB Subnet Group
# ---------------------------
resource "aws_db_subnet_group" "dbsubnet" {
  name = "my-db-subnet"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private2.id
  ]

  tags = {
    Name = "DBSubnetGroup"
  }
}

# ---------------------------
# RDS MySQL
# ---------------------------
resource "aws_db_instance" "mysql" {

  identifier             = "student-db"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  db_name  = "student"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.dbsubnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false

  skip_final_snapshot = true
}