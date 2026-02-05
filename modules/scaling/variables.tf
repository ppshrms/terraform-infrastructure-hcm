variable "customer_name" {
  description = "Customer name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, staging, dev)"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "cpu_scale_out_threshold" {
  description = "CPU percentage threshold to trigger scale out"
  type        = number
  default     = 80
}

variable "memory_scale_out_threshold" {
  description = "Memory percentage threshold to trigger scale out"
  type        = number
  default     = 80
}

variable "scale_evaluation_periods" {
  description = "Number of periods (5 min each) to evaluate before scaling"
  type        = number
  default     = 1
}

variable "scale_cooldown" {
  description = "Cooldown period in seconds between scaling activities"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
