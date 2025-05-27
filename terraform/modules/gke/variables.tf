variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "name" {
  description = "Cluster name prefix"
  type        = string
}

variable "location" {
  description = "GCP region or zone"
  type        = string
}

variable "network" {
  description = "VPC network name"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name"
  type        = string
}

variable "cluster_secondary_range_name" {
  description = "Secondary range name for pods"
  type        = string
}

variable "services_secondary_range_name" {
  description = "Secondary range name for services"
  type        = string
}

variable "peering_range" {
  description = "Name of the peering range"
  type        = string
}

variable "node_count" {
  description = "Number of nodes"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks allowed to access master"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}
