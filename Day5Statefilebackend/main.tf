resource "aws_instance" "name" {
    ami=var.ami_id
    key_name="demo"
    instance_type=var.instance_type
    tags={
        Name="Terraform"
    }


}
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
  
}