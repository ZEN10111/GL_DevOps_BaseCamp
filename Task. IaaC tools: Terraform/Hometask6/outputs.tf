output "grafana_aws_link" {
    value = "http://${module.aws_grafana.instance_public_ip}:3000"
}

output "grafana_azure_link" {
    value = "http://${module.azure_grafana.azure_public_ip}:3000"
}