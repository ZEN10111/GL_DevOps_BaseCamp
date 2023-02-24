resource "google_compute_firewall" "http" {
  name        = "http"
  network = google_compute_network.private.id
  
  allow {
    protocol = "icmp"
  }
 
  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
  
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = google_compute_network.private.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}


resource "google_compute_firewall" "https" {
  name        = "https"
  network = google_compute_network.private.id

  allow {
    protocol  = "tcp"
    ports     = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
  
}
