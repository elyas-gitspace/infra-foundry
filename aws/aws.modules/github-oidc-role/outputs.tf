# Sorties du module github-oidc-role

output "arn" {
  description = "ARN du rôle, à mettre dans le workflow GitHub (role-to-assume)"
  value       = aws_iam_role.this.arn
}

output "name" {
  description = "Nom du rôle"
  value       = aws_iam_role.this.name
}
