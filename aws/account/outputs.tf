output "github_oidc_provider_arn" {
  description = "ARN du fournisseur OIDC GitHub"
  value       = aws_iam_openid_connect_provider.github.arn
}
