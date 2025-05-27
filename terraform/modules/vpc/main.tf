resource "google_compute_network" "vpc" {
  name                    = var.name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.ip_range
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_router" "router" {
  name    = "${var.name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-nat"
  region                             = var.region
  router                             = google_compute_router.router.name
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
