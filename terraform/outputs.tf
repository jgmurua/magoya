

output "id" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.this.id
}
output "arn" {
  description = "EKS Cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "host" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint

}
output "cert" {
  description = "Certificate authority"
  value       = aws_eks_cluster.this.certificate_authority.0.data
}

output "identity" {
  description = "Attribute block containing identity provider information for your cluster"
  value       = aws_eks_cluster.this.identity
}
output "vpc_id" {
  description = "ID of the VPC associated with your cluster."
  value       = aws_eks_cluster.this.vpc_config.0.vpc_id
}
output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication."
  value       = aws_eks_cluster.this.vpc_config.0.cluster_security_group_id
}

output "identity_oidc_issuer" {
  description = "Attribute block containing identity provider information for your cluster"
  # quitar el https:// al inicio del valor utilizando la función replace de Terraform
  value = replace(aws_eks_cluster.this.identity.0.oidc.0.issuer, "https://", "")
}


# Note: Outputs are marked as sensitive
output "cicd_access_key_id" {
  value     = aws_iam_access_key.cicd.id
  sensitive = true
}

output "cicd_secret_access_key" {
  value     = aws_iam_access_key.cicd.secret
  sensitive = true
}
