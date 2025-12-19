module "eks_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name = "eks-${var.cluster_name}-${var.env}"
  vpc_id = var.vpc_id

  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
  ingress_cidr_blocks = concat([
    "0.0.0.0/0"
    ])
  
  tags = {
    "Name" = "eks-${var.cluster_name}-${var.env}"
  }
}