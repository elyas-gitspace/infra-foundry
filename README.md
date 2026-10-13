# infra-foundry

Personal cloud infrastructure, managed with Terraform.

| Stack | Provider | What it creates |
|---|---|---|
| [`aws/pgkube-guard`](aws/pgkube-guard) | AWS | S3 bucket and IAM users to test [pgkube-guard](https://github.com/elyas-gitspace/pgkube-guard) |

## Usage

```bash
cd aws/<stack>
terraform init
terraform plan
terraform apply
```
