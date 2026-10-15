# Les ressources ont été déplacées dans des modules : ces blocs disent à Terraform
# "c'est la même ressource, elle a juste changé d'adresse dans le state".
# Sans eux, Terraform détruirait puis recréerait tout (bucket vidé, access keys changées).
# On peut supprimer ce fichier une fois le refacto appliqué (terraform apply).

# Bucket S3
moved {
  from = aws_s3_bucket.backups
  to   = module.backups_bucket.aws_s3_bucket.this
}
moved {
  from = aws_s3_bucket_public_access_block.backups
  to   = module.backups_bucket.aws_s3_bucket_public_access_block.this
}
moved {
  from = aws_s3_bucket_ownership_controls.backups
  to   = module.backups_bucket.aws_s3_bucket_ownership_controls.this
}
moved {
  from = aws_s3_bucket_server_side_encryption_configuration.backups
  to   = module.backups_bucket.aws_s3_bucket_server_side_encryption_configuration.this
}
moved {
  from = aws_s3_bucket_lifecycle_configuration.backups
  to   = module.backups_bucket.aws_s3_bucket_lifecycle_configuration.this
}

# User de backup
moved {
  from = aws_iam_user.backup
  to   = module.backup_user.aws_iam_user.this
}
moved {
  from = aws_iam_user_policy.backup
  to   = module.backup_user.aws_iam_user_policy.this
}
moved {
  from = aws_iam_access_key.backup
  to   = module.backup_user.aws_iam_access_key.this
}

# User de restore
moved {
  from = aws_iam_user.restore
  to   = module.restore_user.aws_iam_user.this
}
moved {
  from = aws_iam_user_policy.restore
  to   = module.restore_user.aws_iam_user_policy.this
}
moved {
  from = aws_iam_access_key.restore
  to   = module.restore_user.aws_iam_access_key.this
}
