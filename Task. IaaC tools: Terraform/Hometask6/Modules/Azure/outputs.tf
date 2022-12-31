output "azure_public_ip" {
  value = "${data.azurerm_public_ip.main.ip_address}"
}