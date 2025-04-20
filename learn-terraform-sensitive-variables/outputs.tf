output "db_connect_string" {
  description = "MySQL database connection string"
  value       = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
  sensitive = true
}

#will throw a error if you don't set the sensitive=true, because the output is derived from sensitive variables