
resource "google_compute_instance" "webserver" {
  name         = "webserver"
  machine_type = "e2-custom-8-16384"
  tags = ["http-server", "ssh", "https-server" ]
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "35"
      }
    }

  network_interface {
    network = google_compute_network.private.id
    subnetwork = google_compute_subnetwork.private.id
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
  }
}
 


resource "google_sql_database_instance" "private" {
  database_version = "MYSQL_5_7"
  name             = "sql-wordpress"
  region           = var.region

  depends_on = [
  google_service_networking_connection.private]

  settings {
    availability_type = "REGIONAL"
    disk_autoresize   = false
    disk_size         = 50
    disk_type         = "PD_HDD"
    tier              = "db-g1-small"

    backup_configuration {
      enabled            = true
      start_time         = "05:00"
      binary_log_enabled = true
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private.id
    }

    database_flags {
      name  = "max_connections"
      value = 500
    }
  }
   deletion_protection  = "false"
}

resource "google_sql_database" "private" {
  name      = "wordpress"
  instance  = google_sql_database_instance.private.name
  charset   = "utf8"
  collation = "utf8_general_ci"
}


resource "google_sql_user" "private" {
  name     = "wordpress"
  password = file("db_pass.txt")
  instance = google_sql_database_instance.private.name
}




