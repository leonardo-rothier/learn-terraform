provider "aws" {
    region = var.aws_region
}

resource "random_pet" "name" {
    length = 2
    separator = "-"
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "web" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    user_data = file("init-script.sh")

    tags = {
        Name = random_pet.name.id
    }
}