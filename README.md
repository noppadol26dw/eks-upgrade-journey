# EKS 1.33 Phase 1

Terraform project for an EKS cluster at Kubernetes 1.33 with VPC, EKS Blueprints Addons (Karpenter, Argo CD, Argo Rollouts). <br>
Prepared for a later EKS upgrade phase.

## What this creates

- **VPC**: Public and private subnets, NAT gateway, EKS and Karpenter discovery tags
- **EKS cluster**: Kubernetes 1.33, managed addons (coredns, kube-proxy, vpc-cni, eks-pod-identity-agent), one small managed node group
- **Addons**: Karpenter, Argo CD, Argo Rollouts (via EKS Blueprints Addons)

## Prerequisites

- Terraform >= 1.5.7
- AWS CLI configured with credentials that can create EKS, VPC, IAM
- kubectl (after cluster is created)

## Usage

1. Copy the example tfvars and maintain your values there:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars: set cluster_name, aws_region, and any overrides
   ```

   All configurable values (cluster name, region, VPC CIDRs, node group size, Kubernetes version, etc.) are in `terraform.tfvars`. <br>
   Use that file as the single place to maintain values.

2. Initialize and validate:

   ```bash
   terraform init
   terraform validate
   ```

You may see validation warnings about deprecated attributes (e.g. `data.aws_region.current.name`). <br>
Those come from the EKS Blueprints Addons module, not this repo. They are safe to ignore; the config is valid. <br>
The upstream module may switch to `data.aws_region.current.id` in a future release.

3. Plan and apply:

   ```bash
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

4. Configure kubeconfig:

   ```bash
   aws eks update-kubeconfig --region <region> --name <cluster_name>
   ```

## Availability zones

The VPC uses only standard availability zones (Local Zones excluded). EKS and NAT Gateway require standard AZs; regions like ap-southeast-1 (Singapore) include Local Zones that are not supported. <br>
To override, set `availability_zones` in `terraform.tfvars`, e.g. `["ap-southeast-1a", "ap-southeast-1b"]`.

## Karpenter

Subnets and the node security group are tagged for Karpenter discovery. After apply, you may need to create a NodePool and EC2NodeClass (or Provisioner) so Karpenter can provision nodes. <br>
See [Karpenter docs](https://karpenter.sh/) for your Kubernetes version.

## Phase 2

After the cluster is running and addons are healthy, Phase 2 will cover the EKS upgrade workflow.
