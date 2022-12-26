
provider "google" {
  credentials = file("put_file.json")
  project     = "put_project_name"
  region      = "us-central1"
  zone        = "europe-west3-c"
}


resource "google_compute_network" "private" {
  name = "my-network"
}

resource "google_compute_subnetwork" "private" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.private.id
}


resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["http-server", "ssh", "icmp"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      labels = {
        my_label = "web_server"
      }
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.private.id
    access_config {
    }
  }

 metadata_startup_script =  templatefile("D:\\GCP\\install_wp.sh", {
    DB_PASSWORD = file("db_pass.txt")
})
 
}


resource "google_compute_firewall" "rules" {
  project     = "pro-zone-372114"
  name        = "my-firewall-rule"
  network     =  google_compute_network.private.id
  description = "Creates firewall rule targeting tagged instances"

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
