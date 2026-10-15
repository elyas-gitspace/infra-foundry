locals {
  # ARN de tous les objets sous le préfixe pgkube-guard (ex : arn:aws:s3:::bucket/pgkube-guard/*)
  prefix_arn = "${module.backups_bucket.arn}/${var.prefix}*"
}

# ---------- Permissions ----------

# Job de backup : lister, écrire et supprimer les dumps (rétention), uniquement sous le préfixe
data "aws_iam_policy_document" "backup" {
  statement {
    sid       = "ListPrefix"
    actions   = ["s3:ListBucket"]
    resources = [module.backups_bucket.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.prefix}*"]
    }
  }
  statement {
    sid       = "WriteDumps"
    actions   = ["s3:PutObject", "s3:DeleteObject", "s3:AbortMultipartUpload"]
    resources = [local.prefix_arn]
  }
}

# Test de restore : lister et lire les dumps, uniquement sous le préfixe (lecture seule)
data "aws_iam_policy_document" "restore" {
  statement {
    sid       = "ListPrefix"
    actions   = ["s3:ListBucket"]
    resources = [module.backups_bucket.arn]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.prefix}*"]
    }
  }
  statement {
    sid       = "ReadDumps"
    actions   = ["s3:GetObject"]
    resources = [local.prefix_arn]
  }
}

# ---------- Utilisateurs IAM ----------
# Leurs access keys vont dans les Secrets Kubernetes de pgkube-guard

# User utilisé par le CronJob de backup
module "backup_user" {
  source = "../aws.modules/iam-user"

  name        = "pgkube-guard-backup"
  path        = "/pgkube-guard/"
  policy_name = "pgkube-guard-backup-s3"
  policy_json = data.aws_iam_policy_document.backup.json
}

# User utilisé par le test de restore
module "restore_user" {
  source = "../aws.modules/iam-user"

  name        = "pgkube-guard-restore"
  path        = "/pgkube-guard/"
  policy_name = "pgkube-guard-restore-s3"
  policy_json = data.aws_iam_policy_document.restore.json
}
