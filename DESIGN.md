# Design decisions

The root configuration consumes a reusable private network module. Provider mocking validates plans without using AWS credentials. Tests do not prove account quotas, actual CIDR containment or overlap acceptance, AZ capacity, or deployed connectivity. A real sandbox plan remains an explicit manual step.

See README.md for operation and VALIDATION.md for the checks actually performed.
