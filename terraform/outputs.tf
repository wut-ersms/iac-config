output "gke_cluster_name" {
  value = module.gke.cluster_name
}

output "gke_endpoint" {
  value = module.gke.cluster_endpoint
}

output "load_balancer_ip" {
  value = module.load_balancer.load_balancer_ip
}

