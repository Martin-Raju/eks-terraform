terraform {
backend "s3" {
    bucket         = "poc-app-bucket-0123456"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
 }