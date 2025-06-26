resource "aws_s3_bucket" "dev" {
  bucket = var.bucket_name
  force_destroy = false 

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "dev" {
  bucket = aws_s3_bucket.dev.id

  versioning_configuration {
    status = "Enabled"
  }
}
