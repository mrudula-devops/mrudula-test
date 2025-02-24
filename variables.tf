variable "aws_region" {
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "my-eks-cluster"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
}

variable "subnets" {
  description = "List of subnet IDs where the EKS cluster will be deployed"
  type        = list(string)
}

variable "key_name" {
  description = "EC2 Key Pair name to allow SSH access to the worker nodes"
  default     = ""  # Optional: leave empty if not needed
}
