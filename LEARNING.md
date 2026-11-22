# Engineering notes: Cloud infrastructure as code

## Objective

Describe an isolated AWS network in reviewable code with an explicit teardown procedure.

## Design decisions

- Declare a VPC, private subnet, dedicated route table, and isolated security group without opening ingress.
- Keep state and saved plans out of Git; record the provider lock file for reproducible initialization.
- Validate without deploying, then require an account-specific plan before any apply.

## Verification performed

| Check | Observed result |
|---|---|
| `tofu fmt` | Passed; exit 0 as expected |
| `tofu fmt -check` | Passed; exit 0 as expected |
| `tofu init -backend=false -input=false` | Passed; exit 0 as expected |
| `tofu validate -no-color` | Passed; exit 0 as expected |

## What the evidence establishes

Formatting, provider initialization, and configuration validation passed using OpenTofu. Terraform CLI was not run. AWS authentication, planning, deployment, remote state, flow logs, and cost verification remain untested.

## Next exercise

Review a plan in a sandbox AWS account. Document apply and destroy evidence only after executing them. Add flow logs and a controlled remote-state backend as separate exercises.
