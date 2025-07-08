terraform {
backend "s3" {
    bucket         = "poc-app-bucket02-0123456"
    key            = "envs/stage/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}