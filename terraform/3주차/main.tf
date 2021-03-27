provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  backend "s3" {
    bucket = "kuc-terraform-state"
    key = "terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "kuc-terraform-lock"
  }
}