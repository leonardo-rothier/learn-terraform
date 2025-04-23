output "first_tags" {
    description = "Instance tags"
    value = aws_instance.ubuntu[0].tags
}

output "private_addresses" {
    value = aws_instance.ubuntu.*.private_dns
}