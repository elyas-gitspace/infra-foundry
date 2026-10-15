# Sorties du module cloudfront-s3

output "id" {
  description = "ID de la distribution (pour invalider le cache après un déploiement)"
  value       = aws_cloudfront_distribution.this.id
}

output "arn" {
  description = "ARN de la distribution (pour la bucket policy)"
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "URL publique du site (xxxx.cloudfront.net)"
  value       = aws_cloudfront_distribution.this.domain_name
}
