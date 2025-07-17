resource "aws_s3_bucket" "poc" {
  bucket        = "poc-stage-bucket03-0123456"
  force_destroy = false

  tags = {
    Name        = "poc-stage-bucket03-0123456"
    Environment = "live"
  }
}

resource "aws_s3_bucket_versioning" "poc" {
  bucket = aws_s3_bucket.poc.id

  versioning_configuration {
    status = "Enabled"
  }
}
