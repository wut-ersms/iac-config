resource "google_compute_global_address" "ingress_ip" {
  name       = "gke-ingress-ip"
  project    = var.project_id
  ip_version = "IPV4"
}

resource "google_certificate_manager_certificate" "domain_cert" {
  name    = "domain-cert"
  project = var.project_id

  managed {
    domains = [var.domain_name]
  }
}

resource "google_certificate_manager_certificate_map" "cert_map" {
  name    = "domain-map"
  project = var.project_id
}

resource "google_certificate_manager_certificate_map_entry" "cert_map_entry" {
  name     = "domain-map-entry"
  map      = google_certificate_manager_certificate_map.cert_map.name
  project  = var.project_id
  hostname = var.domain_name
  certificates = [
    google_certificate_manager_certificate.domain_cert.id
  ]
}
