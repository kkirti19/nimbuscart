output "web_public_ip" {
  description = "Public IP of the web EC2 instance"
  value       = aws_instance.web.public_ip
}

output "app_private_ip" {
  description = "Private IP of the application EC2 instance"
  value       = aws_instance.app.private_ip
}

output "db_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.postgres.address
}

output "peering_connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.web_data.id
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway public IP - NAT Gateway disabled to avoid charges"
  value       = null
}

output "frontend_url" {
  description = "URL of the frontend"
  value       = "http://${aws_instance.web.public_ip}"
}
