# Valeurs à reporter dans la config / les Secrets Kubernetes de pgkube-guard

output "bucket_name" {
  description = "S3_BUCKET value for pgkube-guard"
  value       = module.backups_bucket.id
}

output "region" {
  description = "AWS_DEFAULT_REGION value for pgkube-guard"
  value       = var.region
}

output "prefix" {
  description = "S3_PREFIX value for pgkube-guard"
  value       = var.prefix
}

output "backup_access_key_id" {
  description = "AWS_ACCESS_KEY_ID of the s3-backup-credentials Secret"
  value       = module.backup_user.access_key_id
}

output "backup_secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY of the s3-backup-credentials Secret"
  value       = module.backup_user.secret_access_key
  sensitive   = true
}

output "restore_access_key_id" {
  description = "AWS_ACCESS_KEY_ID of the s3-restore-credentials Secret"
  value       = module.restore_user.access_key_id
}

output "restore_secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY of the s3-restore-credentials Secret"
  value       = module.restore_user.secret_access_key
  sensitive   = true
}
