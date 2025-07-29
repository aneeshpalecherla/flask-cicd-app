provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh_http" {
  name = "flask-app-sg-v4" # <<< CHANGE THIS LINE to a new, unique name

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "flask_app" {
  ami           = "ami-002c18240e702b6cf" # Your chosen AMI (ensure it's ARM64)
  instance_type = "t4g.micro"            # <<< CHANGE THIS LINE to t4g.micro
  key_name      = "sunny69"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name = "FlaskAppServer"
  }

  user_data = <<EOF
#!/bin/bash
apt update -y
apt install docker.io -y
systemctl start docker
systemctl enable docker
EOF
}

output "public_ip" {
  value = aws_instance.flask_app.public_ip  # THIS LINE IS CORRECTED
}