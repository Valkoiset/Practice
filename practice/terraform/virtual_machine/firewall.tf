resource "google_compute_firewall" "allow_http" {
  name = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  target_tags = ["allow-http"]

  # this tag is necessary to avoid error:
  # * one of source_tags, source_ranges, or source_service_accounts must be defined
  source_tags = ["mynetwork"]
}

resource "google_compute_firewall" "allow_https" {
  name = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["443"]
  }

  target_tags = ["allow-https"]
  source_tags = ["mynetwork"]
}
