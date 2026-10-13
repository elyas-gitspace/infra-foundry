output "bucket_name" {
  description = "S3_BUCKET value for pgkube-guard"
  value       = aws_s3_bucket.backups.bucket
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
  value       = aws_iam_access_key.backup.id
}

output "backup_secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY of the s3-backup-credentials Secret"
  value       = aws_iam_access_key.backup.secret
  sensitive   = true
}

output "restore_access_key_id" {
  description = "AWS_ACCESS_KEY_ID of the s3-restore-credentials Secret"
  value       = aws_iam_access_key.restore.id
}

output "restore_secret_access_key" {
  description = "AWS_SECRET_ACCESS_KEY of the s3-restore-credentials Secret"
  value       = aws_iam_access_key.restore.secret
  sensitive   = true
}
