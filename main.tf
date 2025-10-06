provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "stripe-app-sg"
  description = "Allow HTTP and SSH"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "app_server" {
  ami           = "ami-0d016af584f4febe3" # Ubuntu 24.04 LTS
  instance_type = "t2.micro"
  key_name      = "ansible-key"
  security_groups = [aws_security_group.app_sg.name]
  tags = { Name = "Stripe-App-Server" }
}

resource "aws_eip" "app_ip" {
  instance = aws_instance.app_server.id
}

output "public_ip" {
  value = aws_eip.app_ip.public_ip
}