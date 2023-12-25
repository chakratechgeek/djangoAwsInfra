provider "aws" {
  region = "ap-south-1"
  # Add any other necessary authentication parameters
}

# Reference to the existing VPC by ID
data "aws_vpc" "existing_vpc" {
  id = "vpc-028b13bb3e33cf1ae"  # Replace with your existing VPC ID
}

# Reference to the existing subnet within the existing VPC by ID
data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = "subnet-0d88dc6bc2c2c2b27"  # Replace with your existing subnet ID
}

resource "aws_instance" "example_instance" {
  ami                    = "ami-03f4878755434977f"
  instance_type          = "t2.small"
  key_name               = "django-server-l-0-dev-key"
  subnet_id              = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = false  # Associates a public IP address with the instance
  
}

resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
  # Other EIP configurations if needed
}

data "cloudinit_config" "example" {
  gzip          = false
  base64_encode = false


  part {
    content_type = "text/x-shellscript"
    filename     = "example.sh"
    content  = <<-EOF
      #!/bin/bash
      for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    EOF
  }
}