output "gke_cluster_name" {
  value = module.gke.cluster_name
}

output "gke_endpoint" {
  value = module.gke.cluster_endpoint
}

output "ingress_ip" {
  value = module.ingress.ingress_ip
}

