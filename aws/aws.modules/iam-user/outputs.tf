# Sorties du module iam-user

output "name" {
  description = "Nom de l'utilisateur IAM"
  value       = aws_iam_user.this.name
}

output "arn" {
  description = "ARN de l'utilisateur IAM"
  value       = aws_iam_user.this.arn
}

output "access_key_id" {
  description = "AWS_ACCESS_KEY_ID de l'utilisateur"
  value       = aws_iam_access_key.this.id
}

output "secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY de l'utilisateur"
  value       = aws_iam_access_key.this.secret
  sensitive   = true
}
