terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.96.0"
    }
  }
  required_version = "~> 1.11.0"
}

provider "aws" {
  region = var.region
}