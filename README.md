# infra-foundry

Personal cloud infrastructure, managed with Terraform.

| Stack | Provider | What it creates |
|---|---|---|
| [`aws/account`](aws/account) | AWS | Ressources partagées par tout le compte (fournisseur OIDC GitHub) |
| [`aws/cloud-portofolio`](aws/cloud-portofolio) | AWS | Bucket S3 privé + CloudFront (OAC) pour le site CV + rôle CI de déploiement |
| [`aws/pgkube-guard`](aws/pgkube-guard) | AWS | S3 bucket and IAM users to test [pgkube-guard](https://github.com/elyas-gitspace/pgkube-guard) |

## Structure

```
aws/
├── aws.modules/       # Briques réutilisables (aucun state, appelées par les stacks)
│   ├── s3-bucket/     # Bucket S3 privé, chiffré, sans accès public
│   ├── iam-user/      # User IAM technique + policy inline + access key
│   ├── cloudfront-s3/ # Distribution CloudFront devant un bucket S3 (OAC)
│   └── github-oidc-role/ # Rôle IAM endossable par GitHub Actions via OIDC
├── account/          # Ressources partagées, une fois par compte
├── cloud-portofolio/  # Stack du site CV
└── pgkube-guard/      # Stack d'un projet : appelle les modules, a son propre state
```

Nouveau projet = nouveau dossier `aws/<projet>/` qui appelle les modules avec `source = "../aws.modules/<module>"`.

## Usage

```bash
cd aws/<stack>
terraform init
terraform plan
terraform apply
```
