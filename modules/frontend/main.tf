# Frontend Module - Single EC2 Instance

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

# Frontend EC2 Instance
resource "aws_instance" "frontend" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0]

  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = file("${path.module}/user-data.sh")

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

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend"
    }
  )

  lifecycle {
    ignore_changes = [ami]
  }
}

# Register Frontend instance with Target Group
resource "aws_lb_target_group_attachment" "frontend" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.frontend.id
  port             = 80
}

# Elastic IP for Frontend Instance
resource "aws_eip" "frontend" {
  domain   = "vpc"
  instance = aws_instance.frontend.id

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-frontend-eip"
    }
  )
}
