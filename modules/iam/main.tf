# IAM Module - EC2 Instance Roles & Policies

resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.customer_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-ec2-role"
    }
  )
}

# SSM Policy - for Session Manager
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# CloudWatch Policy - for metrics and logs
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.customer_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_instance_role.name

  tags = merge(
    var.tags,
    {
      Name = "${var.customer_name}-${var.environment}-ec2-profile"
    }
  )
}
