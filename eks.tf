
module "eks" {
  # checkov:skip=CKV_TF_1:Using version tags for modules
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.bu_id}-${var.app_id}-eks"
  kubernetes_version = var.cluster_kubernetes_version
  enabled_log_types  = var.cluster_enabled_log_types
  # checkov:skip=CKV_TF_1:Using version tags for modules
  # checkov:skip=CKV_AWS_260:Public access required
  additional_security_group_ids = compact([var.control_plane_security_group_id])

  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = false
  tags                                     = local.common_tags

  addons = {
    kube-proxy = {
      most_recent = true
    }
  }

  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  control_plane_subnet_ids      = coalesce(var.cluster_control_plane_subnet_ids, var.private_subnet_ids)
  subnet_ids                    = var.private_subnet_ids
  vpc_id                        = var.vpc_id

  access_entries = var.cluster_access_entries

  self_managed_node_groups = var.is_eks_managed_node_group ? null : {
    default = {
      name     = "${var.bu_id}-${var.app_id}-self-managed-node-group"
      ami_id   = data.aws_ami.eks.id
      ami_type = var.ami_type
      auto_scaling_group_tags = {
        "k8s.io/cluster-autoscaler/enabled"                        = "true"
        "k8s.io/cluster-autoscaler/${var.bu_id}-${var.app_id}-eks" = "owned"
      }

      iam_role_additional_policies = {
        ssm        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }

      iam_role_attach_cni_policy    = true
      iam_role_permissions_boundary = var.iam_role_permissions_boundary
      vpc_security_group_ids        = compact([var.node_security_group_id])
      pre_bootstrap_user_data       = file("${path.module}/pre-bootstrap-user-data.sh")
      enable_bootstrap_user_data    = true
      bootstrap_extra_args          = var.ami_type == "AL2_x86_64" ? "--kubelet-extra-args=--node-labels=node.kubernetes.io/instance-type=${var.node_instance_type}, environment=${var.env}" : null
      cloudinit_post_nodeadm        = var.ami_type == "AL2_x86_64" ? [] : coalesce(var.cloudinit_post_nodeadm, local.cloudinit_post_nodeadm)
      cloudinit_pre_nodeadm         = var.cloudinit_pre_nodeadm
      launch_template_tags = {
        Environment  = var.env
        BusinessUnit = var.bu_id
        Application  = var.app_id
      }
      min_size      = var.min_size
      max_size      = var.max_size
      desired_size  = var.desired_size
      instance_type = var.node_instance_type
      tags          = local.common_tags
      capacity_type = "ON_DEMAND"
    }
  }

  eks_managed_node_groups = var.is_eks_managed_node_group ? {
    default = {
      name     = "${var.bu_id}-${var.app_id}-eks-managed-node-group"
      ami_id   = data.aws_ami.eks.id
      ami_type = var.ami_type
      auto_scaling_group_tags = {
        "k8s.io/cluster-autoscaler/enabled"                        = "true"
        "k8s.io/cluster-autoscaler/${var.bu_id}-${var.app_id}-eks" = "owned"
      }

      iam_role_additional_policies = {
        ssm        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        cloudwatch = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }

      iam_role_attach_cni_policy    = true
      iam_role_permissions_boundary = var.iam_role_permissions_boundary
      vpc_security_group_ids        = compact([var.node_security_group_id])
      pre_bootstrap_user_data       = file("${path.module}/pre-bootstrap-user-data.sh")
      enable_bootstrap_user_data    = true
      bootstrap_extra_args          = var.ami_type == "AL2_x86_64" ? "--kubelet-extra-args=--node-labels=node.kubernetes.io/instance-type=${var.node_instance_type}, environment=${var.env}" : null
      cloudinit_post_nodeadm        = var.ami_type == "AL2_x86_64" ? [] : coalesce(var.cloudinit_post_nodeadm, local.cloudinit_post_nodeadm)
      cloudinit_pre_nodeadm         = var.cloudinit_pre_nodeadm
      launch_template_tags = {
        Environment  = var.env
        BusinessUnit = var.bu_id
        Application  = var.app_id
      }
      min_size      = var.min_size
      max_size      = var.max_size
      desired_size  = var.desired_size
      instance_type = var.node_instance_type
      tags          = local.common_tags
      capacity_type = "ON_DEMAND"
    }
  } : null
}

resource "aws_security_group_rule" "allow_all_subnet_traffic" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.eks.cluster_security_group_id
  cidr_blocks       = var.private_subnet_cidrs
  description       = "Allow all traffic from routable subnets traffic"
}
