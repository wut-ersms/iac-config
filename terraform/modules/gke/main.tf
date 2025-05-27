resource "google_service_account" "node_sa" {
  account_id   = "${var.name}-node-sa"
  display_name = "GKE Node Service Account for ${var.name}"
  project      = var.project_id
}

resource "google_project_iam_member" "node_sa_roles" {
  for_each = toset([
    "roles/container.nodeServiceAccount",
    "roles/compute.instanceAdmin.v1",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/storage.objectViewer"
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.node_sa.email}"
}

resource "google_container_cluster" "cluster" {
  name     = var.name
  location = var.location
  project  = var.project_id

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_container_node_pool" "default_pool" {
  name       = "${var.name}-np"
  cluster    = google_container_cluster.cluster.name
  location   = var.location
  project    = var.project_id
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = google_service_account.node_sa.email
    tags            = ["gke-node"]
  }
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [var.peering_range]
}
