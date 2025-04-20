variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "learn-vpc"
}

variable "project_name" {
  default = "project-learn"
}

variable "enable_vpn_gateway" {
  description = "Enable a VPN gateway in your VPC"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Enable a NAT gateway on your VPC"
  type        = bool
  default     = false # always let it false when you are learning, it can bring high costs to your budget
  #but this will be needed when the your ec2 instance need to do outbound requests (ex: yum update, yum install httpd...)
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
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
  default     = 2
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
  default     = "notasecurepassword"
}