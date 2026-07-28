#vpc
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name="Demo"
    }
  
}
#subnet
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name="test-Subnet"
    }
  
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="Delta"
    }
  
}

#internet gateway
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id 
    tags = {
      Name="test-IG"
    }
  
}
#routetable
resource "aws_route_table" "name" {
vpc_id = aws_vpc.name.id
#edit routs
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
}
  
}

#route  assosiation
resource "aws_route_table_association" "name" {
  
  subnet_id = aws_subnet.name.id
  route_table_id=aws_route_table.name.id
}
#security group
resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    vpc_id = aws_vpc.name.id 
    tags = {
      Name="Dev_sg"
    }
  # ... other configuration ... 
  dynamic "ingress" {
    for_each = [22, 80, 443, 8080, 3306, 5432, 3000, 8081]

    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#ec2 creation
resource "aws_instance" "name"{
    ami = "ami-01edba92f9036f76e"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
    
  
}
#elastic ip
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

#nat gateway
resource "aws_nat_gateway" "name" {
allocation_id = aws_eip.nat_eip.id
subnet_id = aws_subnet.name.id
}
