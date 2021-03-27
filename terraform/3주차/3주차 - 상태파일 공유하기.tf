resource "aws_s3_bucket" "terraform_state" {
  bucket = "kuc-terraform-state"

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name = "kuc-terraform-lock"
  hash_key = "LockID"
  read_capacity = 2
  write_capacity = 2

  attribute {
    name = "LockID"
    type = "S"
  }
}

