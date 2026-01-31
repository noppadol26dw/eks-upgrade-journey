# EKS 1.33 Phase 1

Terraform project for an EKS cluster running Kubernetes 1.33 with VPC, EKS Blueprints Addons (Karpenter, Argo CD, Argo Rollouts). This setup prepares for Phase 2: upgrading to EKS 1.34.

## What this creates

- **VPC**: Public and private subnets, NAT gateway, EKS and Karpenter discovery tags
- **EKS cluster**: Kubernetes 1.33, managed addons (coredns, kube-proxy, vpc-cni, eks-pod-identity-agent), one small managed node group
- **Addons**: Karpenter, Argo CD, Argo Rollouts (via EKS Blueprints Addons)

## Prerequisites

- Terraform >= 1.5.7
- AWS CLI configured with credentials that can create EKS, VPC, IAM
- kubectl (after cluster is created)

## Usage

1. Copy the example tfvars and set your values:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars: set cluster_name, aws_region, and any overrides
   ```

   All configurable values (cluster name, region, VPC CIDRs, node group size, Kubernetes version, etc.) are in `terraform.tfvars`. Set values there.

2. Initialize and validate:

   ```bash
   terraform init
   terraform validate
   ```

You may see validation warnings about deprecated attributes (e.g. `data.aws_region.current.name`). These come from the EKS Blueprints Addons module, not this repo. Ignore these warnings; the config is valid. The upstream module may switch to `data.aws_region.current.id` in a future release.

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

The VPC uses only standard availability zones (Local Zones excluded). EKS and NAT Gateway require standard AZs; regions like ap-southeast-1 (Singapore) include Local Zones that are not supported. To override, set `availability_zones` in `terraform.tfvars`, e.g. `["ap-southeast-1a", "ap-southeast-1b"]`.

## Karpenter

Subnets and the node security group are tagged for Karpenter discovery. A NodePool (Spot) and EC2NodeClass (AL2023) are created in `karpenter.tf`. Spot instance types: t3.medium, t3a.medium, t3.large, t3a.large, m5.large, m5a.large, m6i.large. Edit `karpenter.tf` to change instance types. See [Karpenter docs](https://karpenter.sh/) for more.

**EKS Access Entry**: The Karpenter node IAM role is added to the cluster via `aws_eks_access_entry` in `main.tf` (required for AL2023 nodes to join).

## Verification

After applying Terraform, verify the setup:

```bash
# Check cluster status
kubectl get nodes

# Check Karpenter
kubectl get pods -n karpenter
kubectl get nodepools
kubectl get ec2nodeclasses

# Check ArgoCD
kubectl get pods -n argocd

# Check Karpenter logs
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter --tail=50
```

## Testing Karpenter

Deploy a test workload to trigger Karpenter node provisioning:

```bash
kubectl apply -f k8s/test-karpenter.yaml
```

Watch Karpenter provision a new node:

```bash
# Watch pods
kubectl get pods -w

# Watch nodes
kubectl get nodes -w

# Watch NodeClaims (Karpenter's node representation)
kubectl get nodeclaims -w
```

The test deployment requests 1 CPU and 2Gi memory. If your initial node group doesn't have capacity, Karpenter will provision a spot node from your NodePool.

## Phase 2: EKS Upgrade

After the cluster is running and addons are healthy, proceed with Phase 2: upgrading EKS from 1.33 to 1.34.

See **[UPGRADE.md](UPGRADE.md)** for the upgrade guide.

**Quick upgrade steps:**

1. Update `terraform.tfvars`: `kubernetes_version = "1.34"`
2. Update `addons.tf`: Karpenter `chart_version = "1.6.0"` (required for K8s 1.34)
3. Run `terraform plan` and `terraform apply`
4. Verify upgrade: `kubectl get nodes` and check versions

The upgrade guide includes pre-upgrade checks, step-by-step instructions, troubleshooting, and rollback notes.
