# Rôle IAM utilisé par la CI GitHub Actions du site pour le déployer (sync S3 + invalidation CloudFront)

# Compte AWS courant (pour construire l'ARN du fournisseur OIDC)
data "aws_caller_identity" "current" {}

locals {
  # ARN du fournisseur OIDC GitHub, créé dans la stack aws/account
  github_oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

# Permissions minimales pour déployer le site
data "aws_iam_policy_document" "deploy" {
  # aws s3 sync doit lister le bucket pour comparer avec les fichiers locaux
  statement {
    sid       = "ListBucket"
    actions   = ["s3:ListBucket"]
    resources = [module.site_bucket.arn]
  }

  # Écrire les nouveaux fichiers et supprimer ceux qui n'existent plus (sync --delete)
  statement {
    sid       = "WriteObjects"
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["${module.site_bucket.arn}/*"]
  }

  # Vider le cache CloudFront après un déploiement, uniquement sur NOTRE distribution
  statement {
    sid       = "InvalidateCache"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [module.site_cdn.arn]
  }
}

module "ci_role" {
  source = "../aws.modules/github-oidc-role"

  name              = "cloud-portofolio-ci-deploy"
  oidc_provider_arn = local.github_oidc_provider_arn
  github_repo       = var.github_repo # seul ce repo, sur main, peut endosser le rôle
  policy_json       = data.aws_iam_policy_document.deploy.json
}
