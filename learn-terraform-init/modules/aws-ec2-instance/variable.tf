variable "ami_id" {
    type = string
    description = "AMI id for instance."
}

variable "instance_type" {
    type = string
    description = "Type of the EC2 instance"

    default = "t2.micro"
}

variable "instance_name" {
    type = string
    description = "Name of the EC2 instance"
}

variable "project_name" {
    type = string
    description = "name of this example project."

    default = "terraform-init"
}