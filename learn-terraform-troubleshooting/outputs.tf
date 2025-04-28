output "instance_ids" {
  description = "ID of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.id]
}

output "instance_public_ips" {
  description = "Public IP address of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.public_ip]
}

output "instance_names" {
  description = "Tags of the EC2 instance"
  value       = [for instance in aws_instance.web_app : instance.tags.Name]
}

output "my_ip" {
  description = "my ip"
  value = data.http.myip.response_body
}