output "web_server_ip" {
  value = google_compute_instance.webserver.network_interface.0.access_config.0.nat_ip
}

output "web_server_internal_ip" {
  value = google_compute_instance.webserver.network_interface.0.network_ip
}

output "sql_server_ip" {
  value = google_sql_database_instance.private.private_ip_address
}
