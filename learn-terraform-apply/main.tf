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

resource "random_pet" "instance" {
  length = 2
  count = 3
}

resource "aws_instance" "main" {
  count = 3

  instance_type = var.instance_type
  ami = data.aws_ami.ubuntu.id

  tags = {
    Name = "${random_pet.instance[count.index].id}"
    Owner = "${var.project_name}-test"
  }

}

resource "aws_s3_bucket" "example" {
  tags = {
    Name = "Example Bucket"
    Owner = "${var.project_name}-test"
  }
}

resource "aws_s3_object" "example" {
  bucket = aws_s3_bucket.example.bucket

  key    = "main.tf"
  source = "./main.tf"

  etag = filemd5("./main.tf")
}