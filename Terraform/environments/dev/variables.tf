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

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "aws_acc_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_user_name" {
  description = "AWS user name"
  type        = string
}