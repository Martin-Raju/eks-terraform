provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
locals {
  iam_username = split("/", data.aws_caller_identity.current.arn)[1]
}

module "label" {
  source        = "../../modules/terraform-null-label"

  name          = var.cluster_name
  environment   = var.environment
 
}


# --- VPC Module ---
module "vpc" {
  source               = "../../modules/vpc"
  name                 = "${module.label.environment}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "Environment"                               = var.environment

  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# --- EKS Module ---
module "eks" {
  source                          = "../../modules/eks"
  cluster_name                    = module.label.id
  cluster_version                 = var.kubernetes_version
  subnet_ids                      = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  enable_irsa                     = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  tags = {
    cluster = var.cluster_name
  }

  access_entries = {
    user_access = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${local.iam_username}"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }

        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      name           = "${module.label.environment}-node-group"
      min_size       = 1
      max_size       = 3
      desired_size   = 1
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
    }
  }
  eks_managed_node_group_defaults = {
    iam_role_additional_policies = {
      eks_worker   = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      cni          = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      ecr_readonly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      autoscaler   = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
    }
  }
}
