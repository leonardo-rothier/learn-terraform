provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "random_string" "instance_name" {
  length = 10
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name = "ec2-${terraform.workspace}-${random_string.instance_name.id}"
  }
}

resource "random_string" "bucket_name" {
  length = 10
}

resource "aws_s3_bucket" "bucket" {
  bucket = "amzn-s3-${terraform.workspace}-${random_string.bucket_name.id}"

  tags = {
    Name = "S3 Test ${terraform.workspace}"
  }
}