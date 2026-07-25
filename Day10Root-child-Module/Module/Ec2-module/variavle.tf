variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where EC2 will reside"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for EC2"
}