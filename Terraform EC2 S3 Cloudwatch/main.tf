provider "aws" {
  region = "ap-south-1" # Change as needed
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-bucket-841162683682"# Change to a unique name
}

# IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_policy" {
  name        = "s3_access_policy"
  description = "Allows EC2 to access S3"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "s3_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

# Create EC2 Instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0ddfba243cbee3768" # Change to latest Amazon Linux 2 AMI
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "EC2-With-S3-Access"
  }
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ec2_log_group" {
  name              = "/aws/ec2/my-instance-logs"
  retention_in_days = 7
}

# Create CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "ec2_log_stream" {
  name           = "ec2-log-stream"
  log_group_name = aws_cloudwatch_log_group.ec2_log_group.name
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch_logs_policy"
  description = "Allows EC2 to write logs to CloudWatch"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.ec2_log_group.arn}:*"
      }
    ]
  })
}

# Attach CloudWatch Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "cloudwatch_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}
