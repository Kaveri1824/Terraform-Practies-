terraform {
  backend "s3" {
    bucket = "kaverihatkarchvxjgvj"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile=true
   # dynamodb_table = "test"
    encrypt = true
  }
}