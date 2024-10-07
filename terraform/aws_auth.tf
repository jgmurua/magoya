# Wait for the EKS cluster to be ready
resource "time_sleep" "wait_for_cluster" {
  depends_on = [aws_eks_cluster.this]
  create_duration = "60s"
}

# read the aws-auth ConfigMap
data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # wait for the EKS cluster to be ready
  depends_on = [time_sleep.wait_for_cluster]
}

# add the IAM user to the aws-auth ConfigMap
locals {
  existing_map_roles = lookup(data.kubernetes_config_map.aws_auth.data, "mapRoles", "")
  existing_map_users = lookup(data.kubernetes_config_map.aws_auth.data, "mapUsers", "")
  parsed_map_users   = try(yamldecode(local.existing_map_users), [])
}


# Define the aws-auth ConfigMap
resource "local_file" "aws_auth_yaml" {
  content  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: ${aws_iam_role.eksWorkerNodeRole.arn}
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: ${aws_iam_user.cicd.arn}
      username: cicd
      groups:
        - system:masters
YAML
  filename = "${path.module}/aws_auth.yaml"

  # wait for the EKS cluster to be ready
  depends_on = [time_sleep.wait_for_cluster, aws_iam_role.eksWorkerNodeRole, aws_iam_user.cicd]
}
