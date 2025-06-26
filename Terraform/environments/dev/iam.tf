resource "aws_iam_role" "eks_admin_role" {
  name = "EKSAdminRole_dev"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"  
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attach" {
  role       = aws_iam_role.eks_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# Create IAM access entry
resource "aws_eks_access_entry" "eks_user_access" {
  cluster_name   = var.cluster_name
  principal_arn  = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  type    = "STANDARD"
}

# Attach AmazonEKSAdminPolicy
resource "aws_eks_access_policy_association" "eks_admin_policy" {
  cluster_name = var.cluster_name
  principal_arn  = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.eks_user_access]
}

# Attach AmazonEKSClusterAdminPolicy
resource "aws_eks_access_policy_association" "eks_cluster_admin_policy" {
  cluster_name = var.cluster_name
  principal_arn  = "arn:aws:iam::${var.aws_acc_id}:user/${var.aws_user_name}"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.eks_user_access]
}
