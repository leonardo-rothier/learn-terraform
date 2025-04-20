variable "aws_region" {
  description = "AWS region for all resources."
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  default = "learn-vpc"
}

variable "project_name" {
  default = "project-learn"
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC"
  type = bool
  default = false
}

variable "enable_nat_gateway" {
  description = "Enable a NAT gateway on your VPC"
  type = bool
  default = false  # always let it false when you are learning, it can bring high costs to your budget
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type = string
}

variable "instance_count" {
  description = "AWS EC2 instance numbers"
  type = number
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default     = {
    project     = "project-learn",
    environment = "dev",
    owner       = "me@example.com"
  }

  validation {
    condition     = length(var.resource_tags["project"]) <= 16 && length(regexall("[^a-zA-Z0-9-]", var.resource_tags["project"])) == 0
    error_message = "The project tag must be no more than 16 characters, and only contain letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.resource_tags["environment"]) <= 8 && length(regexall("[^a-zA-Z0-9-]", var.resource_tags["environment"])) == 0
    error_message = "The environment tag must be no more than 8 characters, and only contain letters, numbers, and hyphens."
  }
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances per private subnet"
  type        = number
  default     = 1
}

variable "db_username" {
  description = "Database administrator username"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "Database administrator password"
  type = string
  sensitive = true
}