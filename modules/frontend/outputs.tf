output "instance_id" {
  description = "ID of the Frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "instance_arn" {
  description = "ARN of the Frontend EC2 instance"
  value       = aws_instance.frontend.arn
}

output "private_ip" {
  description = "Private IP address of Frontend EC2"
  value       = aws_instance.frontend.private_ip
}

output "private_dns" {
  description = "Private DNS name of Frontend EC2"
  value       = aws_instance.frontend.private_dns
}
