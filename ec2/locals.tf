# locals.tf

locals {
  # Common values that can be reused across the configuration

  # Example: AWS region
  aws_region = "ap-south-1"

  # Example: Define a map of tags to assign to resources
  common_tags = {
    Environment = "Production"
    Department  = "IT"
    Owner       = "Chakravarthi Thangavelu"
    Name        = "django-server-lu-1-dev"
    # Add more tags as needed
  }

}
