# Simple EC2 with Spot Instance Support

This configuration creates a standalone EC2 instance with optional **Spot Instance** support for cost savings.

## Features

- ✅ Standalone EC2 instance
- ✅ **Spot Instance support** (70-90% cost savings)
- ✅ Auto-installs: Git, Docker, Docker Compose, Nginx
- ✅ SSM Session Manager access
- ✅ CloudWatch monitoring
- ✅ Public IP for internet access

## Quick Start

### 1. Configure Spot Instance

Edit `terraform.tfvars`:

```hcl
# Enable Spot Instance (recommended for dev/test)
use_spot_instance = true
spot_max_price    = ""  # Use on-demand price (recommended)

# Or set maximum price
# spot_max_price = "0.02"  # Max $0.02/hour
```

### 2. Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 3. Access EC2

```bash
# Via SSM (no SSH key needed)
aws ssm start-session --target <instance-id>

# Via SSH (if you added key pair)
ssh -i your-key.pem ec2-user@<public-ip>
```

## Spot Instance vs On-Demand

| Feature | On-Demand | Spot Instance |
|---------|-----------|---------------|
| **Price** | Full price | **70-90% cheaper** |
| **Availability** | Always available | May be interrupted |
| **Best for** | Production | Dev/Test/Batch jobs |
| **Interruption** | Never | 2-min warning |

### Cost Example (t3.small)

- **On-Demand**: ~$0.0208/hour = ~$15/month
- **Spot**: ~$0.005/hour = ~$3.6/month
- **Savings**: ~75% cheaper!

## Spot Instance Configuration

### Max Price Options

```hcl
# Option 1: Use on-demand price (recommended)
spot_max_price = ""

# Option 2: Set specific max price
spot_max_price = "0.015"  # $0.015/hour

# Option 3: Disable Spot (use on-demand)
use_spot_instance = false
```

### Spot Type

```hcl
# one-time: Instance terminates when interrupted (default)
spot_type = "one-time"

# persistent: Auto-restart after interruption
spot_type = "persistent"
```

## Handling Spot Interruptions

Spot instances can be interrupted with 2-minute warning. Best practices:

### 1. Use for Stateless Workloads
- Development environments
- CI/CD runners
- Batch processing
- Testing

### 2. Monitor Interruption Warnings

Create CloudWatch alarm or use instance metadata:

```bash
# Check for interruption notice
curl -s http://169.254.169.254/latest/meta-data/spot/instance-action
```

### 3. Use Multiple Instance Types

Increase availability by allowing multiple instance sizes:

```hcl
instance_type = "t3.small"  # Or t3.medium, t3a.small, etc.
```

## Outputs

After deployment:

```bash
terraform output
```

You'll get:
- `ec2_public_ip` - Public IP address
- `ec2_instance_id` - Instance ID for SSM
- `ssh_command` - SSH connection command
- `ssm_command` - SSM connection command

## Cost Comparison

### Monthly costs (continuously running):

| Instance Type | On-Demand | Spot (~75% off) |
|---------------|-----------|-----------------|
| t3.micro | $7.50 | $1.80 |
| t3.small | $15.00 | $3.60 |
| t3.medium | $30.00 | $7.20 |
| t3.large | $60.00 | $14.40 |

## When NOT to Use Spot

❌ Production databases  
❌ Critical services requiring 99.9% uptime  
❌ Long-running stateful applications  
❌ Services without graceful shutdown

## When TO Use Spot

✅ Development/test environments  
✅ CI/CD build servers  
✅ Batch processing  
✅ Machine learning training  
✅ Big data analysis  
✅ Stateless web services with auto-scaling

## Additional Configuration

### Add SSH Key Pair

Edit `main.tf`:

```hcl
resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = "${var.customer_name}-${var.environment}-key"
  public_key = tls_private_key.ec2.public_key_openssh
}

# Add to aws_instance
resource "aws_instance" "standalone_ec2" {
  # ... existing config ...
  key_name = aws_key_pair.ec2.key_name
}
```

### Change Instance Type

```hcl
instance_type = "t3.medium"  # More CPU/RAM
```

### Disable NAT Gateway (save costs)

Already disabled in this config! NAT Gateway costs ~$32/month.

## Clean Up

```bash
terraform destroy
```

## Learn More

- [AWS Spot Instances](https://aws.amazon.com/ec2/spot/)
- [Spot Instance Pricing](https://aws.amazon.com/ec2/spot/pricing/)
- [Spot Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html)
