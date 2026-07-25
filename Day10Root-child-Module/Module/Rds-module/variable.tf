variable "db_name" {
  type    = string
  default = "mydb"
}

variable "db_user" {
  type    = string
  default = "dbadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnets for RDS DB Subnet Group"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID for RDS"
}