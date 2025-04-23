provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

resource "random_string" "vpc_name" {
    length = 4
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~> 5.21.0"

    name = "${var.vpc_name}-${random_string.vpc_name.id}"
    cidr = var.vpc_cidr

    azs = var.vpc_azs
    private_subnets = var.vpc_private_subnets
    public_subnets = var.vpc_public_subnets

    enable_nat_gateway = var.vpc_enable_nat_gateway

    tags = var.vpc_tags

}

resource "random_pet" "instance" {
    length = 4
}

module "ec2_instances" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "~> 5.8.0"

    name = "${random_pet.instance.id}-${count.index}"

    count = 2

    instance_type = "t2.micro"
    ami = "ami-0c5204531f799e0c6"
    vpc_security_group_ids = [module.vpc.default_security_group_id]
    subnet_id = module.vpc.public_subnets[0]

    associate_public_ip_address = true

    tags = {
        Terraform = "true"
        Environment = "dev"
    }

}