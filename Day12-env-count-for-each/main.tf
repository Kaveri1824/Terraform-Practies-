#ec2 creation
resource "aws_instance" "name" {
    ami = var.ami_id
    for_each = local.instance_types
instance_type = each.value

  tags = {
    Name = each.key
  }

}
