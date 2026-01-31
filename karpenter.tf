# Karpenter NodePool (Spot) and EC2NodeClass (AL2023)
# Uses instance profile from EKS Blueprints Addons. Applies via kubectl to avoid kubernetes_manifest schema validation issues with Karpenter CRDs.

locals {
  karpenter_ec2_node_class_yaml = templatefile("${path.module}/k8s/karpenter-ec2-node-class.yaml.tpl", {
    instance_profile = module.eks_blueprints_addons.karpenter.node_instance_profile_name
    cluster_name     = var.cluster_name
  })
  karpenter_node_pool_yaml = templatefile("${path.module}/k8s/karpenter-node-pool.yaml.tpl", {})
}

resource "local_file" "karpenter_ec2_node_class" {
  content  = local.karpenter_ec2_node_class_yaml
  filename = "${path.module}/k8s/karpenter-ec2-node-class.yaml"
}

resource "local_file" "karpenter_node_pool" {
  content  = local.karpenter_node_pool_yaml
  filename = "${path.module}/k8s/karpenter-node-pool.yaml"
}

resource "null_resource" "karpenter_manifests" {
  depends_on = [
    module.eks_blueprints_addons,
    local_file.karpenter_ec2_node_class,
    local_file.karpenter_node_pool,
  ]

  triggers = {
    ec2_node_class = local.karpenter_ec2_node_class_yaml
    node_pool      = local.karpenter_node_pool_yaml
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      kubectl apply -f ${path.module}/k8s/karpenter-ec2-node-class.yaml
      kubectl apply -f ${path.module}/k8s/karpenter-node-pool.yaml
    EOT
  }
}
