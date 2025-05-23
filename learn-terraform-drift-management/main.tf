provider "aws" {
    region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "deployer" {
    key_name = "deployer-key"
    public_key = file("${path.module}/ssh/key.pub")
}

resource "aws_instance" "example" {
    ami = data.aws_ami.ubuntu.id
    key_name = aws_key_pair.deployer.key_name
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg_ssh.id, aws_security_group.sg_web.id]

    user_data = <<-EOF
        #!/bin/bash
        apt update
        apt install apache2 -y
        systemctl start apache2 && systemctl enable apache2
        sed -i "s/80/8080/g" /etc/apache2/ports.conf
        echo "Hello World" > /var/www/html/index.html
        systemctl restart apache2
    EOF
    
    tags = {
        Name          = "terraform-learn-state-ec2"
        drift_example = "v1"
    }
}

resource "aws_security_group" "sg_ssh" {
    name = "sg_ssh"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_web" {
    name = "sg_web"

    description = "allow 8080"
}

resource "aws_security_group_rule" "sg_web" {
    type = "ingress"
    to_port = 8080
    from_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.sg_web.id
}