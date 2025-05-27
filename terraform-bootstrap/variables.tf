variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region to deploy resources"
}

variable "github_repo" {
  type        = string
  description = "Github repository"
}

variable "github_org" {
  type        = string
  description = "Github organisation"
}
