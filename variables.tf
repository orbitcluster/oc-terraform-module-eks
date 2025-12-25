variable "cluster_access_entries" {
  description = "Map of cluster access entries to use for the cluster"
  type        = any
  default     = {}
}

variable "cluster_name" {
  description = "Name to use for the cluster"
  type        = string
}

variable "cluster_kubernetes_version" {
  description = "Kubernetes <major>.<minor> version to use for the cluster"
  type        = string
  default     = "1.33"
}

variable "cluster_control_plane_subnet_ids" {
  description = "List of subnet IDs to use for the cluster control plane"
  type        = list(string)
  default     = null
}

variable "vpc_id" {
  description = "VPC ID to use for the cluster"
  type        = string
}

variable "env" {
  type        = string
  description = "Environment to use for the cluster"
}

variable "extra_nodegroups" {
  type        = map(string)
  description = "Extra nodegroups to use for the cluster"
}

variable "bu_id" {
  type        = string
  description = "Business Unit ID to use for the cluster"
  default     = null
}

variable "app_id" {
  type        = string
  description = "Application ID to use for the cluster"
  default     = null
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where the EKS cluster nodes/ENIs will be created."
  default     = []
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (for load balancers)"
  type        = list(string)
  default     = []
}

variable "node_security_group_id" {
  description = "Security group ID from the networking module to attach to EKS nodes (in addition to the default one)"
  type        = string
  default     = null
}

variable "cluster_security_group_id" {
  description = "Security group ID from the networking module to attach to the EKS control plane (in addition to the default one)"
  type        = string
  default     = null
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of ALB target group ARNs to use for the cluster"
  default     = []
}

variable "cluster_enabled_log_types" {
  description = "List of log types to enable for the cluster"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "cloudinit_pre_nodeadm" {
  description = "Optional: Cloudinit pre-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "cloudinit_post_nodeadm" {
  description = "Optional: Cloudinit post-nodeadm script to use for the cluster"
  type = list(object({
    content_type = string
    content      = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_role_permissions_boundary" {
  description = "IAM role permissions boundary to use for the cluster"
  type        = string
  default     = null
}

variable "ami_type" {
  description = "AMI type to use for the cluster"
  type        = string
  default     = "AL2023_x86_64_STANDARD"

  validation {
    condition     = can(regex("^AL2023_x86_64_STANDARD|AL2_x86_64$", var.ami_type))
    error_message = "AMI type must be AL2023_x86_64_STANDARD or AL2_x86_64"
  }
}

variable "node_instance_type" {
  description = "Instance type to use for the cluster nodes"
  type        = string
  default     = "t3.medium"
}

variable "min_size" {
  description = "Minimum number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes to use for the cluster nodes"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes to use for the cluster nodes"
  type        = number
  default     = 2
}

variable "max_pods_per_node" {
  description = "Maximum number of pods to use for the cluster nodes"
  type        = number
  default     = 30
}
