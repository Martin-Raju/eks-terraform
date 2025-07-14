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

variable "worker_mgmt_ingress_cidrs" {
  type    = list(string)
  default  = ["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.4.0/24","10.0.5.0/24"]
}


