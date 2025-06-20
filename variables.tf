variable "kubernetes_version" {
  description = "kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "default CIDR range of the VPC"
  type        = string
}
variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}