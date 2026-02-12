output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "IDs of private app subnets"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value       = aws_subnet.private_db[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = var.create_nat_gateway ? aws_nat_gateway.main[0].id : null
}

output "internet_gateway_id" {
  description = "ID of the Internet gateway"
  value       = aws_internet_gateway.main.id
}

output "private_route_table_ids" {
  description = "IDs of private route tables (for VPC endpoints)"
  value       = [aws_route_table.private.id]
}
