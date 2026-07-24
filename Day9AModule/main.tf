resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"  
    
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"
}






resource "aws_instance" "name"{
    ami = var.ami_id
    instance_type = var.instance_type
    availability_zone = "us-east-1b"
    subnet_id = var.subnet_id
    
}