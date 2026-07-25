terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 1. Call VPC Child Module
module "vpc" {
  source = "./modules/vpc"
}

# 2. Call EC2 Child Module
module "ec2" {
  source            = "./modules/ec2"
  ami_id            = var.ami_id
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.vpc.ec2_sg_id
}

# 3. Call RDS Child Module
module "rds" {
  source             = "./modules/rds"
  db_password        = var.db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.vpc.rds_sg_id
}