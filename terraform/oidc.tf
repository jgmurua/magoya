# Fetch the TLS certificates from the OIDC issuer URL
data "tls_certificate" "oidc_thumbprint" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Create the IAM OIDC provider
resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_thumbprint.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  # Ensure this resource waits for the cluster to be created
  depends_on = [aws_eks_cluster.this]
}
