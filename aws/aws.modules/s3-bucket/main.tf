# Module s3-bucket : un bucket S3 privé avec les réglages de sécurité de base.
# Réutilisable par n'importe quel projet qui a besoin de stocker des fichiers.

# Le bucket lui-même
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy # true = terraform destroy supprime aussi les fichiers restants
}

# Bloque tout accès public, quoi qu'il arrive
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Désactive les ACL : le propriétaire du bucket possède tous les objets
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Chiffre les fichiers au repos (clé gérée par AWS)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Nettoie les uploads interrompus en plein milieu (invisibles mais facturés)
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_upload_days
    }
  }
}
