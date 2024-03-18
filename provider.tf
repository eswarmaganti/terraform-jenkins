
# Terraform block to register providers
terraform {
  required_providers {
    aws = {
        source="hashicorp/aws"
        version = "~> 5.4.0"
    }
  }
}

# provider block 
provider "aws" {
  region = "us-east-1"
}