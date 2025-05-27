resource "google_storage_bucket" "tf-state" {
  name                        = "${var.project_id}-tf-state"
  location                    = var.region
  project                     = var.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_service_account" "iac-sa" {
  account_id   = "ersms-sa-terraform"
  display_name = "Terraform Service Account"
}

resource "google_project_iam_member" "iac-sa-roles" {
  for_each = toset([
    "roles/owner",
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.iac-sa.email}"
}

resource "google_iam_workload_identity_pool" "ersms-workload-identity-pool" {
  workload_identity_pool_id = "github-actions-pool-ersms-team-e"
}

resource "google_iam_workload_identity_pool_provider" "ersms-workload-identity-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.ersms-workload-identity-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub provider"
  description                        = "GitHub identity pool provider for CI/CD purposes"
  attribute_mapping = {
    "google.subject" : "assertion.sub"
    "attribute.repository" : "assertion.repository"
    "attribute.org"  = "assertion.repository_owner"
    "attribute.refs" = "assertion.ref"
  }
  attribute_condition = "attribute.org == \"${var.github_org}\""
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "ersms-sa-workload-identity-iam" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.iac-sa.name
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.ersms-workload-identity-pool.name}/attribute.repository/${var.github_org}/${var.github_repo}"
}
