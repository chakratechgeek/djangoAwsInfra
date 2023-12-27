#adding this comment
terraform {
  backend "s3" {
    bucket  = var.bucket_name
    #key     = "django/statefile.tfstate"
    key     = var.bucket_key
    region  = local.aws_region
    encrypt = var.need_encrypt
  }
}

provider "aws" {
  region = local.aws_region
  # Add any other necessary authentication parameters
}

# Reference to the existing VPC by ID
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id # Replace with your existing VPC ID
}

# Reference to the existing subnet within the existing VPC by ID
data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = var.subnet_id # Replace with your existing subnet ID
}

resource "aws_instance" "example_instance" {
  ami                         = var.ec_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = var.pub_ip_associate # Associates a public IP address with the instance
  tags = local.common_tags

}

resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
  # Other EIP configurations if needed
}

