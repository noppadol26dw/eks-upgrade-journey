variable "cluster_name" {
  description = "Name of the EKS cluster (used for EKS, VPC tags, and Karpenter discovery)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment label (e.g. dev, staging)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones (defaults to 2 in the selected region)"
  type        = list(string)
  default     = null
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "eks_managed_node_instance_types" {
  description = "Instance types for the initial EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_managed_node_desired_size" {
  description = "Desired number of nodes in the initial managed node group"
  type        = number
  default     = 1
}

variable "eks_managed_node_min_size" {
  description = "Minimum number of nodes in the initial managed node group"
  type        = number
  default     = 1
}

variable "eks_managed_node_max_size" {
  description = "Maximum number of nodes in the initial managed node group"
  type        = number
  default     = 3
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.33"
}
