# Auto Scaling Policies Module

# Scale Out Policy - CPU
resource "aws_autoscaling_policy" "scale_out_cpu" {
  name                   = "${var.customer_name}-${var.environment}-scale-out-cpu"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = var.scale_cooldown
  policy_type            = "SimpleScaling"
}

# Scale Out Alarm - CPU
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.customer_name}-${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.scale_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 # 1 minute

  statistic = "Average"
  threshold = var.cpu_scale_out_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "Triggers when CPU exceeds ${var.cpu_scale_out_threshold}% for ${var.scale_evaluation_periods * 5} minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_out_cpu.arn]

  tags = var.tags
}

# Scale Out Policy - Memory
resource "aws_autoscaling_policy" "scale_out_memory" {
  name                   = "${var.customer_name}-${var.environment}-scale-out-memory"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = var.scale_cooldown
  policy_type            = "SimpleScaling"
}

# Scale Out Alarm - Memory
resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.customer_name}-${var.environment}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.scale_evaluation_periods
  metric_name         = "MemoryUtilization"
  namespace           = "CWAgent"
  period              = 60 # 1 minute

  statistic = "Average"
  threshold = var.memory_scale_out_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "Triggers when Memory exceeds ${var.memory_scale_out_threshold}% for ${var.scale_evaluation_periods * 5} minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_out_memory.arn]

  tags = var.tags
}

# Scale In Policy - CPU
resource "aws_autoscaling_policy" "scale_in_cpu" {
  name                   = "${var.customer_name}-${var.environment}-scale-in-cpu"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = var.scale_cooldown
  policy_type            = "SimpleScaling"
}

# Scale In Alarm - CPU
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.customer_name}-${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.scale_evaluation_periods * 2 # Longer period before scaling in
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = "Triggers when CPU is below 20% for ${var.scale_evaluation_periods * 10} minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_in_cpu.arn]

  tags = var.tags
}
