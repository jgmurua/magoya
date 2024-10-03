
resource "aws_iam_role" "eksWorkerNodeRole" {
  name = "eksWorkerNodeRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksWorkerNodeRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksWorkerNodeRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksWorkerNodeRole.name
}

resource "aws_eks_node_group" "this_public_spot" {
  count           = var.create_public_spot_node_group ? 1 : 0
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-nodeGroup-public-spot"
  node_role_arn   = aws_iam_role.eksWorkerNodeRole.arn
  subnet_ids      = module.vpc.public_subnets
  instance_types  = var.instance_types

  ami_type      = "AL2_x86_64"
  capacity_type = "SPOT"

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "cluster-autoscaler-public-spot"    = "owned"
  }
}

resource "aws_eks_node_group" "this_private_spot" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-nodeGroup-private-spot"
  node_role_arn   = aws_iam_role.eksWorkerNodeRole.arn
  subnet_ids      = module.vpc.private_subnets
  instance_types  = var.instance_types

  ami_type      = "AL2_x86_64"
  capacity_type = "SPOT"

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "cluster-autoscaler-private-spot"   = "owned"
  }
}