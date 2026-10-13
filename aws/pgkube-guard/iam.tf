locals {
  prefix_arn = "${aws_s3_bucket.backups.arn}/${var.prefix}*"
}

# Backup job: list, write and delete dumps (retention) under the prefix only
data "aws_iam_policy_document" "backup" {
  statement {
    sid       = "ListPrefix"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.backups.arn]
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

# Restore test: list and read dumps under the prefix only
data "aws_iam_policy_document" "restore" {
  statement {
    sid       = "ListPrefix"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.backups.arn]
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

resource "aws_iam_user" "backup" {
  name = "pgkube-guard-backup"
  path = "/pgkube-guard/"
}

resource "aws_iam_user" "restore" {
  name = "pgkube-guard-restore"
  path = "/pgkube-guard/"
}

resource "aws_iam_user_policy" "backup" {
  name   = "pgkube-guard-backup-s3"
  user   = aws_iam_user.backup.name
  policy = data.aws_iam_policy_document.backup.json
}

resource "aws_iam_user_policy" "restore" {
  name   = "pgkube-guard-restore-s3"
  user   = aws_iam_user.restore.name
  policy = data.aws_iam_policy_document.restore.json
}

# Access keys used in the pgkube-guard Kubernetes Secrets (stored in the state, keep it out of git)
resource "aws_iam_access_key" "backup" {
  user = aws_iam_user.backup.name
}

resource "aws_iam_access_key" "restore" {
  user = aws_iam_user.restore.name
}
