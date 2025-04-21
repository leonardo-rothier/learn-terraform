terraform {
  cloud {
    organization = "leonardo-rothier-terraform-cloud"
    workspaces {
      name = "learn-terraform-data-sources-app"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.7.0"
    }
  }
  required_version = "~> 1.11.0"
}
