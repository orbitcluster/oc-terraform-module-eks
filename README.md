## Usage

```hcl
module "eks" {
  source = "github.com/orbitcluster/oc-terraform-module-eks"

  cluster_name = "example-cluster"
  env          = "dev"
  vpc_id       = "vpc-12345678"

  routable_subnet_ids = ["subnet-12345678", "subnet-87654321"]

  extra_nodegroups = {
    "example-ng" = "t3.medium"
  }
}

## Development

### Pre-commit Hooks

This repository uses [pre-commit](https://pre-commit.com/) to ensure code quality and security.

1.  **Install pre-commit**:
    ```bash
    pip install pre-commit
    ```
2.  **Install hooks**:
    ```bash
    pre-commit install
    ```
3.  **Run checks**:
    ```bash
    pre-commit run --all-files
    ```

### Testing

This module uses native Terraform testing (`terraform test`).

To run tests locally:

1.  Ensure you have AWS credentials configured.
2.  Run the tests:
    ```bash
    terraform test
    ```

## CI/CD

This repository uses GitHub Actions for automated testing and release management.

### Workflows

*   **CI**: Triggered on push to any branch and pull requests.
    *   Runs `terraform validate`.
    *   Runs `terraform test` (configuring AWS credentials via secrets).
*   **Release**: Triggered on push to `main`.
    *   Uses [Semantic Release](https://github.com/semantic-release/semantic-release) to analyze commit messages.
    *   Automatically creates a new version tag and GitHub release.

### Secrets

The following GitHub Secrets are required for the CI to function:

*   `OC_ACCESS_KEY_ID`: AWS Access Key ID.
*   `OC_SECRET_ACCESS_KEY`: AWS Secret Access Key.
*   `OC_ROLE_TO_ASSUME`: ARN of the IAM role to assume (e.g., `arn:aws:iam::ACCOUNT_ID:role/OrbitClusterEKSAdmin`).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.15.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.0 |
| <a name="module_eks_sg"></a> [eks\_sg](#module\_eks\_sg) | terraform-aws-modules/security-group/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group_rule.allow_all_subnet_traffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | AMI type to use for the cluster | `string` | `"AL2023_x86_64_STANDARD"` | no |
| <a name="input_cloudinit_post_nodeadm"></a> [cloudinit\_post\_nodeadm](#input\_cloudinit\_post\_nodeadm) | Optional: Cloudinit post-nodeadm script to use for the cluster | <pre>list(object({<br/>    content_type = string<br/>    content      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cloudinit_pre_nodeadm"></a> [cloudinit\_pre\_nodeadm](#input\_cloudinit\_pre\_nodeadm) | Optional: Cloudinit pre-nodeadm script to use for the cluster | <pre>list(object({<br/>    content_type = string<br/>    content      = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_access_entries"></a> [cluster\_access\_entries](#input\_cluster\_access\_entries) | Map of cluster access entries to use for the cluster | `any` | `{}` | no |
| <a name="input_cluster_control_plane_subnet_ids"></a> [cluster\_control\_plane\_subnet\_ids](#input\_cluster\_control\_plane\_subnet\_ids) | List of subnet IDs to use for the cluster control plane | `list(string)` | `null` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | List of log types to enable for the cluster | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_cluster_kubernetes_version"></a> [cluster\_kubernetes\_version](#input\_cluster\_kubernetes\_version) | Kubernetes <major>.<minor> version to use for the cluster | `string` | `"1.33"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name to use for the cluster | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of nodes to use for the cluster nodes | `number` | `2` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment to use for the cluster | `string` | n/a | yes |
| <a name="input_extra_nodegroups"></a> [extra\_nodegroups](#input\_extra\_nodegroups) | Extra nodegroups to use for the cluster | `map(string)` | n/a | yes |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | IAM role permissions boundary to use for the cluster | `string` | `null` | no |
| <a name="input_max_pods_per_node"></a> [max\_pods\_per\_node](#input\_max\_pods\_per\_node) | Maximum number of pods to use for the cluster nodes | `number` | `30` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of nodes to use for the cluster nodes | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of nodes to use for the cluster nodes | `number` | `2` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Instance type to use for the cluster nodes | `string` | `"t3.medium"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Organization ID to use for the cluster | `string` | `"org-1234567890"` | no |
| <a name="input_routable_subnet_ids"></a> [routable\_subnet\_ids](#input\_routable\_subnet\_ids) | List of subnet IDs where the EKS cluster plane(ENIs) will be created. It will be used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | List of ALB target group ARNs to use for the cluster | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to use for the cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_asg_names"></a> [cluster\_asg\_names](#output\_cluster\_asg\_names) | List of Auto Scaling Group names for the cluster nodes |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate authority data for the cluster to communicate with the API server |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for the cluster API server |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | ID of the primary security group for the cluster nodes |
<!-- END_TF_DOCS -->
