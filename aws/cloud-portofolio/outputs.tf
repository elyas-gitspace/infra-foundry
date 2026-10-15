# Infos utiles pour déployer le contenu du site

output "bucket_name" {
  description = "Bucket où uploader le site (aws s3 sync ./site s3://<bucket_name>)"
  value       = module.site_bucket.id
}

output "distribution_id" {
  description = "ID CloudFront, pour vider le cache après un déploiement (aws cloudfront create-invalidation)"
  value       = module.site_cdn.id
}

output "site_url" {
  description = "URL publique du site"
  value       = "https://${module.site_cdn.domain_name}"
}
