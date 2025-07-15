terraform {
backend "s3" {
    bucket         = "poc-prod-bucket02-0123456"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}