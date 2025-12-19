variable "cluster_access_entries" {
  description = "Map of cluster access entries to use for the cluster"
  type = map(string)
  default = {}
}

variable "cluster_name" {
  description = "Name to use for the cluster"
  type = string
}

variable "cluster_kubernetes_version" {
  description = "Kubernetes <major>.<minor> version to use for the cluster"
  type    = string
  default = "1.33"
}

variable "cluster_control_plane_subnet_ids" {
  description = "List of subnet IDs to use for the cluster control plane"
  type = list(string)
  default = null
}

variable "vpc_id" {
  description = "VPC ID to use for the cluster"
  type = string
}

variable "env" {
  type = string
  description = "Environment to use for the cluster"
}

variable "extra_nodegroups" {
  type = map(string)
  description = "Extra nodegroups to use for the cluster"
}

variable "org_id" {
  type = string
  description = "Organization ID to use for the cluster"
  default = "org-1234567890"

  validation {
    condition     = length(var.org_id) == 12 && substr(var.org_id, 0, 4) == "org-"
    error_message = "Organization ID must be 12 characters long and start with 'org-'"
  }
}

variable "routable_subnet_ids" {
  type = list(string)
  description = "List of subnet IDs where the EKS cluster plane(ENIs) will be created. It will be used for expanding the pool of subnets used by nodes/node groups without replacing the EKS control plane"
  default = []
}

variable "target_group_arns" {
  type = list(string)
  description = "List of ALB target group ARNs to use for the cluster"
  default = []
}

variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the cluster"
  type = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudinit_pre_nodeadm" {
  description = "Optional: Cloudinit pre-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content = string
  }))
  default = []
}

variable "cloudinit_post_nodeadm" {
  description = "Optional: Cloudinit post-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_role_permissions_boundary" {
  description = "IAM role permissions boundary to use for the cluster"
  type = string
  default = null
}

variable "ami_type" {
  description = "AMI type to use for the cluster"
  type = string
  default = "AL2023_x86_64_STANDARD"

  validation {
    condition     = can(regex("^AL2023_x86_64_STANDARD|AL2_x86_64$", var.ami_type))
    error_message = "AMI type must be AL2023_x86_64_STANDARD or AL2_x86_64"
  }
}

variable "node_instance_type" {
  description = "Instance type to use for the cluster nodes"
  type = string
  default = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of nodes to use for the cluster nodes"
  type = number
  default = 2
}

variable "max_size" {
  description = "Maximum number of nodes to use for the cluster nodes"
  type = number
  default = 3
}

variable "desired_size" {
  description = "Desired number of nodes to use for the cluster nodes"
  type = number
  default = 2
}

variable "max_pods_per_node" {
  description = "Maximum number of pods to use for the cluster nodes"
  type = number
  default = 30
}