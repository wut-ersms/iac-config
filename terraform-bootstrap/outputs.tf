output "service_account_email" {
  value = google_service_account.iac-sa.email
}

output "gcs_bucket_name" {
  value = google_storage_bucket.tf-state.name
}

output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.ersms-workload-identity-provider.name
}
