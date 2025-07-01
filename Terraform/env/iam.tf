
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [module.eks]
  create_duration = "30s"
}


resource "aws_eks_access_entry" "eks_user_access" {
  cluster_name  = var.cluster_name
  principal_arn = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  type          = "STANDARD"

 depends_on = [time_sleep.wait_30_seconds]
}

# Attach AmazonEKSAdminPolicy
resource "aws_eks_access_policy_association" "eks_admin_policy" {
  cluster_name   = var.cluster_name
  principal_arn  = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  policy_arn     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.eks_user_access]
}

# Attach AmazonEKSClusterAdminPolicy
resource "aws_eks_access_policy_association" "eks_cluster_admin_policy" {
  cluster_name   = var.cluster_name
  principal_arn  = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  policy_arn     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.eks_user_access]
}

