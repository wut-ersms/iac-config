variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "Base name for VPC resources"
  type        = string
}

variable "region" {
  description = "Region for VPC resources"
  type        = string
}

variable "ip_range" {
  description = "CIDR range for subnet"
  type        = string
}
