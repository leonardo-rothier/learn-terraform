provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-075686beab831bb7f" # Ubuntu Server 24.04 LTS
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}