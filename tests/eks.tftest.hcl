
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
    cluster_name        = "test-cluster"
    env                 = "test"
    bu_id               = "test-bu"
    app_id              = "test-app"
    vpc_id              = run.setup.vpc_id
    private_subnet_ids  = run.setup.subnet_ids
    extra_nodegroups = {
      "test-ng" = "t3.medium"
    }
  }

  assert {
    condition     = module.eks.cluster_name == "test-bu-test-app-test-cluster"
    error_message = "Cluster name did not match expected value"
  }

  assert {
    condition     = module.eks.cluster_endpoint != null
    error_message = "Cluster endpoint should not be null"
  }

  assert {
    condition     = module.eks.cluster_certificate_authority_data != null
    error_message = "Cluster CA data should not be null"
  }

  assert {
    condition     = module.eks.cluster_primary_security_group_id != null
    error_message = "Cluster primary security group ID should not be null"
  }
}
