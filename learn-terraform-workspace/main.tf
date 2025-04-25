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

resource "random_id" "instance_suffix" {
  byte_length = 5
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name = "ec2-${terraform.workspace}-${random_id.instance_suffix.id}"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 5
}

resource "aws_s3_bucket" "bucket" {
  bucket = "amzn-s3-${terraform.workspace}-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "S3 Test ${terraform.workspace}"
  }
}