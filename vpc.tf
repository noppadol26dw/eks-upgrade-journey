data "aws_availability_zones" "available" {
  state = "available"

  # EKS and NAT Gateway need standard AZs only (excluding local zones)
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

locals {
  azs = var.availability_zones != null ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
  # Subnet CIDRs must match number of AZs
  private_subnets = length(var.private_subnet_cidrs) >= length(local.azs) ? slice(var.private_subnet_cidrs, 0, length(local.azs)) : [for i in range(length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, i + 1)]
  public_subnets  = length(var.public_subnet_cidrs) >= length(local.azs) ? slice(var.public_subnet_cidrs, 0, length(local.azs)) : [for i in range(length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, i + 101)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"           = "1"
    "karpenter.sh/discovery"                    = var.cluster_name
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
    "karpenter.sh/discovery"                    = var.cluster_name
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
