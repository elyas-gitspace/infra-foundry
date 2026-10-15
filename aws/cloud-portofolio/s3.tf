# Bucket privé qui contient les fichiers du site (HTML, CSS, images...)
# Il n'est jamais public : seul CloudFront peut le lire (voir la policy plus bas)
module "site_bucket" {
  source = "../aws.modules/s3-bucket"

  bucket_name = var.bucket_name
}

# Bucket policy (dernière étape d'OAC) : autorise CloudFront à lire les fichiers,
# mais UNIQUEMENT les requêtes qui viennent de NOTRE distribution
data "aws_iam_policy_document" "site_bucket" {
  statement {
    sid       = "AllowCloudFrontRead"
    actions   = ["s3:GetObject"]
    resources = ["${module.site_bucket.arn}/*"]

    # Qui : le service CloudFront
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    # À condition que ce soit notre distribution (et pas celle d'un autre compte)
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.site_cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "site_bucket" {
  bucket = module.site_bucket.id
  policy = data.aws_iam_policy_document.site_bucket.json
}
