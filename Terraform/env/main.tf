provider "aws" {
<<<<<<< HEAD
  region = var.aws_region
=======
  region 								                            = var.aws_region
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
}

data "aws_availability_zones" "available" {}

# --- VPC Module ---
module "vpc" {
<<<<<<< HEAD
  source               = "./modules/vpc"
  name                 = "${var.cluster_name}-vpc"
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
=======
  source  								                          = "./modules/vpc"
  name                 							                = "${var.cluster_name}-vpc"
  cidr                 							                = var.vpc_cidr
  azs                  							                = data.aws_availability_zones.available.names
  private_subnets      							                = var.private_subnets
  public_subnets       							                = var.public_subnets
  enable_nat_gateway   							                = true
  single_nat_gateway   							                = true
  enable_dns_hostnames 						                  = true
  enable_dns_support   									            = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" 		= "shared"
    "Environment"                                   = var.environment
    
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" 		= "shared"
    "kubernetes.io/role/elb"                    		= "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" 		= "shared"
    "kubernetes.io/role/internal-elb"           		= "1"
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
  }
}

# --- EKS Module ---
module "eks" {
<<<<<<< HEAD
  source                          = "./modules/eks"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.kubernetes_version
  subnet_ids                      = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  enable_irsa                     = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  tags = {
    cluster = var.cluster_name
=======
  source  										                      = "./modules/eks"
  cluster_name                    							    = var.cluster_name
  cluster_version                 							    = var.kubernetes_version
  subnet_ids                      							    = module.vpc.private_subnets
  vpc_id                          							    = module.vpc.vpc_id
  enable_irsa                     							    = true
  cluster_endpoint_public_access  							    = true
  cluster_endpoint_private_access 							    = true

  tags = {
    cluster 										                    = var.cluster_name
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
  }

  access_entries = {
    user_access = {
<<<<<<< HEAD
      principal_arn = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type = "cluster"
=======
      principal_arn 									              = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"

      policy_associations = {
        admin = {
          policy_arn 									              = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type 									                  = "cluster"
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
          }
        }

        cluster_admin = {
<<<<<<< HEAD
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
=======
          policy_arn 									              = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type 									                  = "cluster"
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
          }
        }
      }
    }
  }

<<<<<<< HEAD
  eks_managed_node_groups = {
    default = {
      name           = "${var.cluster_name}-ng"
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
=======
 eks_managed_node_groups = {
  default = {
    name          									                = "${var.cluster_name}-ng"
    min_size      									                = 1
    max_size      									                = 3
    desired_size  									                = 1
    instance_types 									                = ["t3.medium"]
    ami_type       									                = "AL2_x86_64"
  }
 }
eks_managed_node_group_defaults = {
  iam_role_additional_policies = {
    eks_worker      									              = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    cni             									              = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    ecr_readonly    									              = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    autoscaler      									              = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
>>>>>>> d4d58841599ed06c70c841a6fb77d112f712f099
  }
}
