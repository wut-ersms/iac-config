resource "google_compute_global_address" "lb_ip" {
  name    = "${var.name}-ip"
  project = var.project_id
}

resource "google_compute_managed_ssl_certificate" "cert" {
  name    = "${var.name}-cert"
  project = var.project_id

  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_health_check" "http" {
  name    = "${var.name}-hc"
  project = var.project_id

  http_health_check {
    port         = var.health_check_port
    request_path = "/"
  }

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

resource "google_compute_backend_service" "backend" {
  name                            = "${var.name}-backend"
  project                         = var.project_id
  protocol                        = "HTTP"
  port_name                       = "http"
  load_balancing_scheme           = "EXTERNAL"
  connection_draining_timeout_sec = 30
  timeout_sec                     = 30

  backend {
    group = var.instance_group
  }

  health_checks = [google_compute_health_check.http.id]
}

resource "google_compute_url_map" "url_map" {
  name    = "${var.name}-url-map"
  project = var.project_id

  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${var.name}-https-proxy"
  project          = var.project_id
  ssl_certificates = [google_compute_managed_ssl_certificate.cert.id]
  url_map          = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.name}-https-forwarding-rule"
  project               = var.project_id
  target                = google_compute_target_https_proxy.https_proxy.id
  port_range            = "443"
  ip_address            = google_compute_global_address.lb_ip.address
  load_balancing_scheme = "EXTERNAL"
}
