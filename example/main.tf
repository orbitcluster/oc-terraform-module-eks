################################################################################
# EKS Module
################################################################################

module "eks" {
  source = "../"

  cluster_name               = local.name
  cluster_kubernetes_version = "1.30"
  vpc_id                     = "<vpc-id>"                       # Placeholder
  routable_subnet_ids        = ["<subnet-id1>", "<subnet-id2>"] # Placeholder
  env                        = "dev"
  org_id                     = "org-1234567890"

  ami_type = "AL2023_x86_64_STANDARD"

  extra_nodegroups = {}

  node_instance_type = "t3.small"
  desired_size       = 2
  min_size           = 1
  max_size           = 3

  tags = local.tags
}
