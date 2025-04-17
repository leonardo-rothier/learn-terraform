
resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type

    tags = {
        Name = var.instance_name
        Owner = "${var.project_name}-test"
    }
}