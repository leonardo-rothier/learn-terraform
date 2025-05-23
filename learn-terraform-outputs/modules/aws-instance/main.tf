data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app"{
    count = var.instance_count

    instance_type = var.instance_type
    ami = data.aws_ami.amazon_linux.id

    subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)] # round robin subnet attribution
    vpc_security_group_ids = var.security_group_ids

    user_data = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install httpd -y
        sudo systemctl enable httpd
        sudo systemctl start httpd
        echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
        EOF
    
    tags = var.tags

 }