# main.tf - Stripe App Infrastructure

# 1. AWS Provider
provider "aws" {
  region = "us-east-1"
}

# 2. Security Group
resource "aws_security_group" "app_sg" {
  name        = "stripe-app-sg"
  description = "Allow HTTP and SSH inbound traffic"

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

# 3. EC2 Instance
resource "aws_instance" "app_server" {
  ami           = "ami-0d016af584f4febe3" # ✅ Ubuntu 24.04 LTS in us-east-1
  instance_type = "t2.micro"
  key_name      = "ansible-key" # ✅ must match AWS Console keypair

  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "Stripe-App-Server"
  }
}

# 4. Elastic IP
resource "aws_eip" "app_ip" {
  instance = aws_instance.app_server.id
}

# 5. Output public IP
output "public_ip" {
  value = aws_eip.app_ip.public_ip
}
# --- JENKINS SERVER INFRASTRUCTURE ---

# 6. A New Security Group (Firewall) just for Jenkins
# This opens port 8080 so we can access the Jenkins webpage,
# and port 22 so we can SSH into it if needed.
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow Jenkins and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# 7. A New EC2 Instance (Server) just for Jenkins
# This is the server where the Jenkins application will live.
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0d016af584f4febe3" # ✅ Ubuntu 24.04 LTS in us-east-1 
  instance_type = "t2.micro"             # Free Tier eligible
  key_name      = "ansible-key"          # Use the same key we created

  # We attach the new Jenkins security group to this server
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "Jenkins-Server"
  }
}

# 8. An Elastic IP for the Jenkins Server
# So it has a permanent, static IP address.
resource "aws_eip" "jenkins_ip" {
  instance = aws_instance.jenkins_server.id
}

# 9. Output the Jenkins Server's public IP address
# So we know its address after it's created.
output "jenkins_server_ip" {
  value = aws_eip.jenkins_ip.public_ip
}

