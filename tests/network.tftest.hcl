mock_provider "aws" {}

run "private_network_defaults" {
  command = plan
  assert {
    condition     = module.network.subnet_count == 2
    error_message = "Expected two private subnets."
  }
  assert {
    condition     = alltrue([for enabled in module.network.public_ip_assignment : !enabled])
    error_message = "Private subnets must not assign public IP addresses."
  }
  assert {
    condition     = module.network.egress_rule_count == 0
    error_message = "The isolated group must not allow egress by default."
  }
}

run "reject_overbroad_vpc" {
  command = plan
  variables {
    vpc_cidr = "10.0.0.0/12"
  }
  expect_failures = [var.vpc_cidr]
}

run "reject_single_zone" {
  command = plan
  variables {
    private_subnets = {
      a = { cidr = "10.42.1.0/24", az = "us-east-1a" }
      b = { cidr = "10.42.2.0/24", az = "us-east-1a" }
    }
  }
  expect_failures = [var.private_subnets]
}
