output "load_balancer_ip" {
  description = "Public IP address of the HTTPS Load Balancer"
  value       = google_compute_global_address.lb_ip.address
}
