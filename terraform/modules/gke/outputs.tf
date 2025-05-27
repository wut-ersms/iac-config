output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.cluster.endpoint
}

output "node_pool_name" {
  description = "Name of the node pool"
  value       = google_container_node_pool.default_pool.name
}

output "instance_group_urls" {
  description = "List of instance group URLs (used by load balancer)"
  value       = google_container_node_pool.default_pool.instance_group_urls
}

output "node_service_account_email" {
  description = "Email of the GKE node service account"
  value       = google_service_account.node_sa.email
}
