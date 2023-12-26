#adding this comment
terraform {
  backend "s3" {
    bucket  = "temp1983"
    key     = "django/statefile.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-south-1"
  # Add any other necessary authentication parameters
}

# Reference to the existing VPC by ID
data "aws_vpc" "existing_vpc" {
  id = "vpc-028b13bb3e33cf1ae" # Replace with your existing VPC ID
}

# Reference to the existing subnet within the existing VPC by ID
data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = "subnet-0d88dc6bc2c2c2b27" # Replace with your existing subnet ID
}

resource "aws_instance" "example_instance" {
  ami                         = "ami-03f4878755434977f"
  instance_type               = "t2.small"
  key_name                    = "django-server-l-0-dev-key"
  subnet_id                   = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = false # Associates a public IP address with the instance
  spot_price                  = "0.005"

}

resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
  # Other EIP configurations if needed
}

#adding this comment for testing
