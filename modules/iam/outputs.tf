output "instance_profile_name" {
  description = "EC2 instance profile name"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "instance_role_arn" {
  description = "EC2 instance role ARN"
  value       = aws_iam_role.ec2_instance_role.arn
}

output "rds_monitoring_role_arn" {
  description = "RDS Enhanced Monitoring role ARN"
  value       = aws_iam_role.rds_monitoring_role.arn
}
