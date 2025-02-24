module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.10.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"  

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets  

  eks_managed_node_groups = {
    eks_node_group = {
      desired_size    = var.desired_capacity
      max_size        = var.max_capacity
      min_size        = var.min_capacity
      instance_types  = [var.node_instance_type]
      key_name        = var.key_name  
      ami_type        = "AL2_x86_64"
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

