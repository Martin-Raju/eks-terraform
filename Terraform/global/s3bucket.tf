resource "aws_s3_bucket" "poc" {
  bucket = "poc-app-bucket02-0123456"
  force_destroy = false 

  tags = {
    Name        = "poc-app-bucket02-0123456"
    Environment = "live"
  }
}

resource "aws_s3_bucket_versioning" "poc" {
  bucket = aws_s3_bucket.poc.id

  versioning_configuration {
    status = "Enabled"
  }
}
