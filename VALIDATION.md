# Validation

`tofu fmt -check -recursive`, initialization, validation, and three mocked-provider tests passed. Assertions cover two subnets, public-IP assignment disabled, zero egress rules, invalid VPC prefix rejection, and single-zone rejection.

## Coverage

Mocked AWS provider plans with local state. Cloud connectivity, quotas, and account-specific behavior are separate deployment checks.
