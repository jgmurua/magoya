
# Wait for cluster to be ready
resource "time_sleep" "wait_for_cluster" {
  depends_on = [aws_eks_cluster.this]

  create_duration = "60s"
}

data "null_data_source" "cluster_ready" {
  depends_on = [
    aws_eks_cluster.this,
    time_sleep.wait_for_cluster,
  ]
}

# Read the existing aws-auth ConfigMap
data "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [data.null_data_source.cluster_ready]
}

# Proceed with adding the cicd user
locals {
  existing_map_roles = lookup(data.kubernetes_config_map.aws_auth.data, "mapRoles", "")
  existing_map_users = lookup(data.kubernetes_config_map.aws_auth.data, "mapUsers", "")
  parsed_map_users   = try(yamldecode(local.existing_map_users), [])
}

locals {
  new_map_users = concat(
    local.parsed_map_users,
    [
      {
        userarn  = aws_iam_user.cicd.arn
        username = "cicd"
        groups   = ["ci-cd-group"]
      }
    ]
  )
}


