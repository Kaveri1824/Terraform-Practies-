resource "aws_instance" "name" {
  ami=var.ami_id
  key_name = "demo"
  instance_type =var.instance_type
  tags ={
Name="Test"
  }
}
