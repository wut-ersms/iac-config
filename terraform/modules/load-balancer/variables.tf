variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "Base name for all resources"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the HTTPS certificate (e.g. app.yourdomain.com)"
  type        = string
}

variable "instance_group" {
  description = "Self-link of the instance group (e.g. from a GKE node pool)"
  type        = string
}

variable "health_check_port" {
  description = "Port for backend health check (NodePort service port)"
  type        = number
}
