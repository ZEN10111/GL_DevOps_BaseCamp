module "aws_grafana" {
    source ="./Modules/AWS"
  # AWS module configurations 
  #region        = "eu-central-1"
  #instance_type = "t2.micro"
  #key_name      = "id_rsa"
  #ssh_pub_key   = "ssh_pub_key/id_rsa.pub"
  #ami           = "ami-09c5ba4f838d8684a"

}

module "azure_grafana" {
    source ="./Modules/Azure"
  # Azure module configurations 
  #prefix                  = "Grafana"
  #location                = "Norway East"
  #vm_size                 = "Standard_D2s_v3"
  #vm_admin_username       = "ubuntu"
  #ssh_pub_key             = "ssh_pub_key/id_rsa.pub"
  #distr_publisher         = "Canonical"
  #distr_offer             = "UbuntuServer"
  #distr_sku               = "18.04-LTS"
  #distr_version           = "latest"

}
