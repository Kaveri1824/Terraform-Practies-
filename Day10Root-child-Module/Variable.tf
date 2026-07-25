variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type    = string
  default = "ami-0c7217cdde317cfec" # Amazon Linux 2023 (us-east-1)
}

variable "db_password" {
  type      = string
  sensitive = true
}