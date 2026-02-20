terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Module 1: IAM (จำเป็น - สำหรับ EC2 role)
module "iam" {
  source = "../../../modules/iam"

  customer_name = var.customer_name
  environment   = var.environment
  tags          = { Environment = var.environment }
}

# Module 2: Networking (จำเป็น - VPC, Subnet)
module "networking" {
  source = "../../../modules/networking"

  customer_name = var.customer_name
  environment   = var.environment
  vpc_cidr      = var.vpc_cidr
  tags          = { Environment = var.environment }
}

# Module 3: Security Groups (เลือกใช้แค่ที่ต้องการ)
module "security_groups" {
  source = "../../../modules/security-groups"

  customer_name = var.customer_name
  environment   = var.environment
  vpc_id        = module.networking.vpc_id
  tags          = { Environment = var.environment }
}

# Module 4: EC2 with Spot Instance support
resource "aws_instance" "standalone_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.networking.public_subnet_ids[0]

  vpc_security_group_ids = [module.security_groups.frontend_sg_id]
  iam_instance_profile   = module.iam.instance_profile_name

  user_data = file("${path.module}/user-data.sh")

  # Spot Instance configuration
  dynamic "instance_market_options" {
    for_each = var.use_spot_instance ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price          = var.spot_max_price != "" ? var.spot_max_price : null
        spot_instance_type = var.spot_type
      }
    }
  }

  tags = {
    Name = "${var.customer_name}-${var.environment}-ec2"
    Type = var.use_spot_instance ? "spot" : "on-demand"
  }
}
