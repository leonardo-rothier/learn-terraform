terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.9"
    }
    random = {
        source = "hashicorp/random"
        version = "3.5"
    }
    time = {
        source = "hashicorp/time"
        version = "0.9.1"
    }
  }
  cloud {
    organization = "leonardo-rothier-terraform-cloud"
    workspaces {
        name = "learn-terraform-apply"
    }
  }
  required_version = "1.11.4"
}