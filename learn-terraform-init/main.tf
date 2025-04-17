provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_pet" "instance_name" {
  length = 4
}

# local module
module "ec2-instance" {
  source = "./modules/aws-ec2-instance"

  ami_id        = data.aws_ami.ubuntu.id
  instance_name = random_pet.instance_name.id
}

# remote module
module "hello" {
  source  = "joatmon08/hello/random"
  version = "6.0.0"

  hellos = {
    hello        = "World"
    second_hello = random_pet.instance_name.id
  }

  some_key = "secret"
}