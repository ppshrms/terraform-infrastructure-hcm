#!/bin/bash
# Simple EC2 User Data Script

# Update system
yum update -y

# Install basic tools
yum install -y git docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install CloudWatch agent (for monitoring)
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Create a simple health check endpoint
mkdir -p /var/www/html
cat > /var/www/html/health.html <<EOF
<!DOCTYPE html>
<html>
<head><title>Health Check</title></head>
<body>
  <h1>OK</h1>
  <p>Instance is running</p>
  <p>Hostname: $(hostname)</p>
  <p>Instance ID: $(ec2-metadata --instance-id | cut -d " " -f 2)</p>
</body>
</html>
EOF

# Install and start nginx for health checks
amazon-linux-extras install -y nginx1
systemctl start nginx
systemctl enable nginx

# Copy health check to nginx
cp /var/www/html/health.html /usr/share/nginx/html/

echo "User data script completed!" > /var/log/user-data.log
