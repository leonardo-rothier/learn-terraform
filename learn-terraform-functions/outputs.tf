output "web_public_address" {
    value = "${aws_instance.web.public_ip}:8080"
}

output "web_public_ip" {
    value = aws_instance.web.public_ip
}

output "ami_value" {
    value = lookup(var.aws_amis, var.aws_region)
}