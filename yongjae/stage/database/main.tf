provider "aws" {
  access_key = "AKIAQLQYUTXEII5WMCD5"
  secret_key = "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"
  region = "ap-northeast-2"
}

resource "aws_db_instance" "legend-mysql-01" {
  engine = "mysql"
  allocated_storage = 10
  instance_class = "db.t2.micro"
  name = "legend_mysql_01"
  username = "admin"
  password = var.db_password
  skip_final_snapshot = true
}

resource "aws_s3_bucket" "legend-bucket-01" {
  bucket = "yj-terraform-test1"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

/** s3생성완료후 실행
terraform {
  backend "s3" {
    bucket = "yj-terraform-test1"
    key = "./terraform.tfstate"
    encrypt = true
    region = "ap-northeast-2"
    dynamodb_table = "legend-dynamodb-01"
  }
}

/** dynamo db 생성
resource "aws_dynamodb_table" "terraform_lock" {
  name = "legend-dynamodb-01"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
**/
