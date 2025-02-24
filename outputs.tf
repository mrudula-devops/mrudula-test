output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}



output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_id
}


output "cluster_certificate_authority_data" {
  description = "Cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
}
