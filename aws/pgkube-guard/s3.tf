# Bucket qui stocke les dumps Postgres de pgkube-guard
module "backups_bucket" {
  source = "../aws.modules/s3-bucket"

  bucket_name   = var.bucket_name
  force_destroy = true # bucket de test : on peut le détruire même s'il reste des dumps
}
