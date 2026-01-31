module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_karpenter = true
  enable_argocd    = true
  argocd = {
    chart_version = "9.3.7"
    namespace     = "argocd"
  }
  enable_argo_rollouts  = true
  enable_metrics_server = true

  create_delay_duration = "30s"

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
