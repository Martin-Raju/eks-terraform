terraform {
backend "s3" {
    bucket         = "poc-app-bucket-0123456"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}