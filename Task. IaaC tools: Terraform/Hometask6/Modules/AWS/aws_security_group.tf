resource "aws_security_group" "security_group1" {
  name        = "allow_http"
  description = "Allow TLS inbound traffic"
 
  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "grafana"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

