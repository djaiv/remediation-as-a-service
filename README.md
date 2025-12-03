
# Remediation-as-a-Service Demo - Azure + GitHub Actions

This repo is a ready-to-fork skeleton for your SECON ISC2 demo. It shows a closed-loop remediation flow:
- PR with insecure Terraform
- CI runs Checkov and OPA via Conftest and fails on policy violation
- An auto-fix workflow opens a bot PR with a patch
- On merge to main, CD applies to Azure using GitHub OIDC

## Repo layout

```
.github/workflows/   - CI, auto-fix, and CD pipelines
policies/            - OPA policies for Conftest
terraform/           - Intentionally insecure Terraform for the demo
scripts/             - Auto remediation script
```

## Quick start

1. Fork this repo.
2. In your Azure subscription, create or choose a resource group. Example: `rg-raas-demo`.
3. In GitHub repo Settings, set repository `Variables` for:
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_LOCATION` - example: `eastus`
   - `AZURE_RG` - example: `rg-raas-demo`

4. Configure GitHub OIDC for Azure:
   - Use `azure/login@v2` with federated credentials. Map your repo and environments to Azure AD with a federated credential at subscription or RG scope. Give least privilege needed for the demo.

5. Open a PR that touches `terraform/` to trigger CI. CI will fail on OPA policy denies.
6. The Auto-Fix workflow will create a bot PR with a patch. Review and merge.
7. The CD workflow will apply using Terraform and Azure OIDC.

## Notes

- Policies here flag public blob access on Storage and RDP ingress from Any. You can add more rules as needed.
- The auto-fix script is intentionally simple for stage reliability. In production, consider parsing HCL or using tfupdate for safer edits.
- The CD job targets `main`. Enforce branch protection and required reviews for a complete story.
