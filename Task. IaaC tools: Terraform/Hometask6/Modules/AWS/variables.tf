variable "region" {
    default = "eu-central-1"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ami" {
    default = "ami-09c5ba4f838d8684a"
}

variable "user_data" {
    default = "user_data/install_grafana.sh"
}

variable "ssh_pub_key" {
    default = "ssh_pub_key/id_rsa.pub"
}

variable "key_name" {
    default = "id_rsa"
}

