data "aws_subnet" "selected" {
  for_each = toset(var.routable_subnet_ids)
  id       = each.value
}

data "aws_ami" "eks" {
  # checkov:skip=CKV_AWS_386:Using standard EKS AMI pattern
  most_recent = true
  filter {
    name   = "name"
    values = [var.ami_type == "AL2023_x86_64_STANDARD" ? "amazon-eks-node-*" : "amazon-eks-node-*"]
  }
}
