variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "customer_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "172.18.0.0/16"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type    = string
  default = "" # ใช้ latest Amazon Linux 2
}

variable "use_spot_instance" {
  description = "Use Spot Instance instead of On-Demand"
  type        = bool
  default     = false
}

variable "spot_max_price" {
  description = "Maximum price for Spot Instance (empty = on-demand price)"
  type        = string
  default     = ""
}

variable "spot_type" {
  description = "Spot request type: one-time or persistent"
  type        = string
  default     = "one-time"
}
