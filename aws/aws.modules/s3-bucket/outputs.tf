# Sorties du module s3-bucket, utilisées par les projets qui l'appellent

output "id" {
  description = "Nom/ID du bucket"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "ARN du bucket (pour écrire des policies IAM)"
  value       = aws_s3_bucket.this.arn
}

output "regional_domain_name" {
  description = "Nom de domaine régional du bucket (sert d'origine à CloudFront)"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
