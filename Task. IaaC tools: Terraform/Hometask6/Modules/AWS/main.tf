
resource "aws_instance" "grafana" {
  instance_type     = var.instance_type
  ami               = var.ami
  vpc_security_group_ids  =  [aws_security_group.security_group1.id]
  key_name                = aws_key_pair.deployer.key_name
  user_data = file(var.user_data)
}


