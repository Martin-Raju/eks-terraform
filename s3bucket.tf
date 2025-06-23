resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  force_destroy = true 

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

terraform {
  backend "s3" {
    bucket         = "my-poc-app-bucket-989313"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

