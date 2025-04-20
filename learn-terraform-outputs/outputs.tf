output "vpc_id" {
  description = "ID of project VPC"
  value = module.vpc.vpc_id
}

output "lb_url" {
  description = "URL of load balancer"
  value = "http://${module.elb_http.elb_dns_name}"
}

output "web_server_count" {
  description = "Number of web server provisioned"
  value = length(module.ec2_instances.instance_ids)
}