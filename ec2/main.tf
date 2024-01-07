

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
  count                       = var.create_instance ? 1 : 0
  ami                         = var.ec_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = var.pub_ip_associate # Associates a public IP address with the instance
  tags                        = local.common_tags

}

resource "aws_spot_instance_request" "example_instance" {
  count                       = var.spot_create_instance ? 1 : 0
  ami                         = var.ec_ami
  spot_type                   = "one-time"
  wait_for_fulfillment        = "true"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = var.pub_ip_associate # Associates a public IP address with the instance
  tags                        = local.common_tags

}

resource "aws_eip" "example_eip" {
  instance = length(aws_instance.example_instance) > 0 ? aws_instance.example_instance[0].id : null
  # Other EIP configurations if needed
  depends_on = [aws_instance.example_instance]
}




