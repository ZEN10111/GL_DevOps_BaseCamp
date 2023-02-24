

resource "google_compute_network" "private" {
  name = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "my-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.private.id
}


resource "google_compute_global_address" "private" {
  name          = "private-ip-db-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private.id
}

resource "google_service_networking_connection" "private" {
  network                 = google_compute_network.private.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private.name]
}

