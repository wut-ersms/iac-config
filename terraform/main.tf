module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  name       = "main-vpc"
  region     = var.region
  ip_range   = "10.0.0.0/16"
}

# Reserve IP ranges for cluster networking
resource "google_compute_global_address" "gke_pods_range" {
  name          = "gke-pods-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.vpc_id
  project       = var.project_id
}

resource "google_compute_global_address" "gke_services_range" {
  name          = "gke-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = module.vpc.vpc_id
  project       = var.project_id
}

module "gke" {
  source                         = "./modules/gke"
  project_id                     = var.project_id
  name                           = "main-cluster"
  location                       = var.zone
  network                        = module.vpc.vpc_id
  subnetwork                     = module.vpc.subnet_id
  cluster_secondary_range_name   = google_compute_global_address.gke_pods_range.name
  services_secondary_range_name  = google_compute_global_address.gke_services_range.name
  peering_range                  = google_compute_global_address.gke_pods_range.name
  node_count                     = 1
  machine_type                   = "e2-standard-4"
  node_service_account           = var.node_sa_email

  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "allow-all-for-now"
    }
  ]
}

module "load_balancer" {
  source            = "./modules/load-balancer"
  project_id        = var.project_id
  name              = "https-lb"
  domain_name       = var.domain_name
  instance_group    = module.gke.instance_group_urls[0]
  health_check_port = 30080
}
