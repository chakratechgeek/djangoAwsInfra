# Variables
variable "aws_region" {
  default = "us-west-2" # Change this to your desired AWS region
}

variable "vpc_id" {
  default = "your-vpc-id" # Replace with your VPC ID
}

variable "subnet_ids" {
  default = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"] # Replace with your subnet IDs
}

variable "eip_allocation_id" {
  default = "eipalloc-xxxxxxxxxxxxxx" # Replace with your EIP allocation ID
}

# Create an Elastic Load Balancer (ELB)
resource "aws_elb" "example_elb" {
  name               = "example-elb"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  subnets            = var.subnet_ids
  listener {
    lb_port           = 8000
    lb_protocol       = "http"
    instance_port     = 8000
    instance_protocol = "http"
  }
}

# Associate Elastic IP (EIP) with the Load Balancer
resource "aws_elb_attachment" "example_eip_attachment" {
  elb         = aws_elb.example_elb.name
  instance    = null # Since ELB doesn't have instances, use null
  instance_id = null # Since ELB doesn't have instance IDs, use null
  # Use your EIP allocation ID
  eip = var.eip_allocation_id
}

# Open port 8000 in the ELB security group
resource "aws_security_group_rule" "example_sg_rule" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  security_group_id = aws_elb.example_elb.security_groups[0] # Get the security group ID of the ELB
  cidr_blocks       = ["0.0.0.0/0"]                          # Replace with your desired CIDR blocks
}
