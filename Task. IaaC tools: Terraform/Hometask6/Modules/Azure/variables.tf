variable "user_data" {
    default = "user_data/install_grafana.sh"
}

variable "ssh_pub_key" {
    default = "ssh_pub_key/id_rsa.pub"
}

variable "location" {
    default = "Norway East"
}
variable "prefix" {
  default = "grafana"
}

variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "vm_admin_username" {
  default = "ubuntu"
}

variable "admin_ssh_key_username" {
  default = "ubuntu"
}

variable "distr_publisher" {
  default = "Canonical"
}

variable "distr_offer" {
  default = "UbuntuServer"
}

variable "distr_sku" {
  default = "18.04-LTS"
}

variable "distr_version" {
  default = "latest"
}

