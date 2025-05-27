variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "zone" {
  type        = string
  description = "Zone"
}

variable "domain_name" {
  type        = string
  description = "FQDN for the HTTPS load balancer (e.g. app.example.com)"
}
