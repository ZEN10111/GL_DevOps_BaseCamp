provider "google" {
  credentials = file("put_credentials_name_file_here")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

