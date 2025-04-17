terraform {
    cloud {
        organization = "leonardo-rothier-terraform-cloud"

        workspaces {
          name = "learn-terraform-plan"
        }
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.9"
        }
        random = {
            source = "hashicorp/random"
            version = "3.7.1"
        }
    }
}
