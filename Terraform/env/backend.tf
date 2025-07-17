terraform {
  backend "s3" {
    bucket  = "poc-stage-bucket03-0123456"
    key     = "envs/stage/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}