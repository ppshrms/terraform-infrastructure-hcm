# Base Instance Outputs
# Base Instance Outputs
output "base_instance_id" {
  description = "ID of the base backend instance"
  value       = var.create_backend_base ? aws_instance.backend_base[0].id : null
}

output "base_instance_private_ip" {
  description = "Private IP of the base backend instance"
  value       = var.create_backend_base ? aws_instance.backend_base[0].private_ip : null
}

# ASG Outputs
output "asg_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.backend.id
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.backend.name
}

output "asg_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.backend.arn
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.backend.id
}

output "launch_template_latest_version" {
  description = "Latest version of the Launch Template"
  value       = aws_launch_template.backend.latest_version
}
