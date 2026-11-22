# Terraform AWS network lab

## Purpose

Move from configuring individual hosts to describing cloud networking as reviewed infrastructure code.

## Run locally

```sh
terraform init -backend=false
terraform fmt -check
terraform validate
```

## Scope and limitations

Validation requires downloading the AWS provider. Deployment requires an AWS sandbox account and a reviewed plan. This repository does not claim a live deployment or cost estimate.

## Engineering notes

See [LEARNING.md](LEARNING.md) for the design decisions, verification evidence,
and next steps. Never commit credentials, private hostnames, or real incident data.

## Network parameters

Set `vpc_cidr` and `subnet_cidr` with a local variable file or `-var`. Validation checks IPv4 CIDR syntax. Review subnet containment, overlap, provider subnet-size limits, and account context in the plan before applying. No deployment has been performed.
