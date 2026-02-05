# Backend Module - Base Instance + Auto Scaling Group

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Base Backend Instance (for config/setup)
resource "aws_instance" "backend_base" {
  count = var.create_backend_base ? 1 : 0

  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = base64encode(file("${path.module}/user-data.sh"))

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  monitoring = true

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-backend-base"
      Role = "backend-base"
    }
  )

  lifecycle {
    ignore_changes = [ami, user_data]
  }
}

# Target Group Attachment for Base Instance
resource "aws_lb_target_group_attachment" "backend_base" {
  count = var.create_backend_base ? 1 : 0

  target_group_arn = var.target_group_arn
  target_id        = aws_instance.backend_base[0].id
  port             = 80
}

# Launch Template for ASG
resource "aws_launch_template" "backend" {
  name_prefix   = "${var.customer_name}-${var.environment}-backend-asg-"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = [var.security_group_id]

  user_data = base64encode(file("${path.module}/user-data.sh"))

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      volume_size           = var.root_volume_size
      delete_on_termination = true
      encrypted             = true
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "${var.customer_name}-${var.environment}-backend-asg"
        Role = "backend-asg"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group (starts at 0, scales up to 4)
resource "aws_autoscaling_group" "backend" {
  name                      = "${var.customer_name}-${var.environment}-backend-asg"
  min_size                  = 0            # Start with 0 ASG instances (base instance handles initial load)
  max_size                  = var.max_size # Max 4 instances
  desired_capacity          = 0            # Start with 0
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "${var.customer_name}-${var.environment}-backend-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
