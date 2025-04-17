variable "project_name" {
    type = string
    description = "name of this sample project"

    default = "terraform-plan"
}

variable "region" {
    type = string
    description = "AWS region that will be used for all aws resources"

    default = "us-east-1"
}

variable "secret_key" {
    type = string
    sensitive = true
    description = "Secret key for hello module"
}