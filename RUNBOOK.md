# Cloud plan and teardown procedure

1. Authenticate to your own sandbox account with temporary credentials.
2. Confirm the account and region independently before planning.
3. Review variable values, ownership tags, AZs, subnet containment, and overlap.
4. Run `tofu init`, formatting, validation, and mocked tests.
5. Run `tofu plan -out=lab.tfplan` and inspect every proposed resource.
6. Apply only the reviewed saved plan if you choose to deploy the lab.
7. Verify outputs and network controls in that account.
8. Run `tofu destroy` after a separate review and confirm resources are removed.

Saved plans, state, credentials, and local variable files stay out of Git. No real
AWS plan, apply, or destroy was performed during local portfolio verification.
