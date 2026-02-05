output "scale_out_cpu_policy_arn" {
  description = "ARN of the CPU scale out policy"
  value       = aws_autoscaling_policy.scale_out_cpu.arn
}

output "scale_out_memory_policy_arn" {
  description = "ARN of the Memory scale out policy"
  value       = aws_autoscaling_policy.scale_out_memory.arn
}

output "scale_in_cpu_policy_arn" {
  description = "ARN of the CPU scale in policy"
  value       = aws_autoscaling_policy.scale_in_cpu.arn
}

output "cpu_high_alarm_arn" {
  description = "ARN of the CPU high CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "memory_high_alarm_arn" {
  description = "ARN of the Memory high CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.memory_high.arn
}

output "cpu_low_alarm_arn" {
  description = "ARN of the CPU low CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_low.arn
}
