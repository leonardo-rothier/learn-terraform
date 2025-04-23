terraform {
  cloud {
    organization = "leonardo-rothier-terraform-cloud"
    workspaces {
      name = "learn-terraform-expressions"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
  }

  required_version = "~> 1.11.0"
}