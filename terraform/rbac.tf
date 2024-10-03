# rbac.tf

resource "kubernetes_cluster_role" "ci_cd_role" {
  metadata {
    name = "ci-cd-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "deployments", "replicasets", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets", "replicasets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "ci_cd_binding" {
  metadata {
    name = "ci-cd-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ci_cd_role.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "ci-cd-group"
    api_group = "rbac.authorization.k8s.io"
  }
}
