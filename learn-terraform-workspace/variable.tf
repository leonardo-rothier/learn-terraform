variable "aws_region" {
  description = "All aws resource region"
  type = string
}

variable "instance_type" {
  description = "instance type of our ec2 instances"
  type = string
}

variable "env" {
  description = "The environment this configuration are provisioning"
  type = string
}