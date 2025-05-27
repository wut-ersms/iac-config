output "ingress_ip" {
  description = "Public IP address of the ingress"
  value       = google_compute_global_address.ingress_ip.address
}
