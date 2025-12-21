
run "setup" {
  module {
    source = "./tests/setup"
  }

  variables {
    region = "us-east-1"
  }
}

run "plan" {
  command = plan

  variables {
    cluster_name = "test-cluster"
    env          = "test"
    vpc_id       = run.setup.vpc_id
    routable_subnet_ids = run.setup.subnet_ids
    extra_nodegroups = {
      "test-ng" = "t3.medium"
    }
  }

  assert {
    condition     = module.eks.cluster_name == "test-cluster"
    error_message = "Cluster name did not match expected value"
  }
}
