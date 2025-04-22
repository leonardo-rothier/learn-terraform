variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
    description = "Type of all EC2 instance"
    type = string
    default = "t2.micro"
}