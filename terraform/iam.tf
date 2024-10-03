
resource "aws_iam_user" "cicd" {
  name = "cicd"
}

resource "aws_iam_access_key" "cicd" {
  user = aws_iam_user.cicd.name
}

data "aws_iam_policy_document" "cicd_eks_policy" {
  statement {
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:AccessKubernetesApi",
      "eks:ListUpdates",
      "eks:DescribeUpdate"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cicd_eks_policy" {
  name   = "cicd-eks-policy"
  policy = data.aws_iam_policy_document.cicd_eks_policy.json
}

resource "aws_iam_user_policy_attachment" "cicd_eks_policy_attach" {
  user       = aws_iam_user.cicd.name
  policy_arn = aws_iam_policy.cicd_eks_policy.arn
}

