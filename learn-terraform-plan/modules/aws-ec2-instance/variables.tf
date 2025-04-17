variable "ami_id" {
    type = string

    description = "AMI ID for instance."
}

variable "project_name" {
    type = string
}

variable "instance_type" {
    type = string
    description = "Type of the EC2 machine"

    default = "t2.micro"
} 

variable "instance_name" {
    type = string

    description = "Name of the EC2 instance"
}