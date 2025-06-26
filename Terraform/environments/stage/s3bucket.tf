resource "aws_s3_bucket" "stage" {
  bucket = var.bucket_name
  force_destroy = false 

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "stage" {
  bucket = aws_s3_bucket.stage.id

  versioning_configuration {
    status = "Enabled"
  }
}
