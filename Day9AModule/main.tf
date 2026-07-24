resource "aws_vpc" "default" {
    cidr_block = "10.0.0.0/16"  
    
}




resource "aws_instance" "name" {
    ami = "ami-01edba92f9036f76e"
    instance_type = "t3.micro"
    availability_zone = "us-east-1a"
    
}