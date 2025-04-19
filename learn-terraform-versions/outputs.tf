output "domain_name" {
    description = "Public DNS name of the ec2 instance"
    value = aws_instance.web.public_dns
}

output "application_url" {
    description = "URL of the example application"
    value = "${aws_instance.web.public_ip}/index.php"
}
