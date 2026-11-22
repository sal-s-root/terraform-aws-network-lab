# Plan and teardown

1. Use a sandbox AWS account with your own short-lived credentials.
2. Run `terraform init`, `terraform fmt -check`, and `terraform validate`.
3. Run `terraform plan -out=lab.tfplan`; review account, region, and all resources.
4. Apply only after reviewing the plan: `terraform apply lab.tfplan`.
5. Record outputs without credentials. Destroy the lab with `terraform destroy`.
6. Verify that resources are removed in the intended account and region.

OpenTofu can run this configuration using `tofu` in place of `terraform`.
The isolated subnet has no internet gateway, NAT, or default internet route.
No compute, public endpoints, or monitoring resources are provisioned.
The default VPC security group is not attached to workloads by this lab.
Terraform state may contain sensitive data; it is ignored here. A team deployment
needs an access-controlled remote backend and locking configured separately.

No AWS plan, apply, or destroy has been executed as part of portfolio creation.
