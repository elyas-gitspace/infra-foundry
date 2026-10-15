# Module cloudfront-s3 : une distribution CloudFront qui sert le contenu d'un bucket S3 privé.
# CloudFront accède au bucket via OAC (Origin Access Control) :
# il signe ses requêtes vers S3, et le bucket n'accepte que ces requêtes signées.
# ⚠️ Le projet appelant doit ajouter la bucket policy qui autorise cette distribution.

# Politique de cache gérée par AWS, optimisée pour du contenu statique
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

# OAC : l'"identité" avec laquelle CloudFront se présente au bucket S3
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = var.name
  description                       = "Accès de CloudFront au bucket ${var.bucket_id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always" # signe toujours les requêtes vers S3
  signing_protocol                  = "sigv4"
}

# La distribution : le CDN qui reçoit les visiteurs et va chercher les fichiers dans S3
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = var.name
  default_root_object = var.default_root_object # fichier servi quand on appelle "/"
  is_ipv6_enabled     = true
  http_version        = "http2and3"
  price_class         = var.price_class

  # D'où viennent les fichiers : le bucket S3, accédé via l'OAC
  origin {
    origin_id                = "s3-${var.bucket_id}"
    domain_name              = var.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  # Comportement par défaut pour toutes les URLs
  default_cache_behavior {
    target_origin_id       = "s3-${var.bucket_id}"
    viewer_protocol_policy = "redirect-to-https" # http → https automatiquement
    allowed_methods        = ["GET", "HEAD"]     # site statique : lecture seule
    cached_methods         = ["GET", "HEAD"]
    compress               = true # gzip/brotli pour des pages plus légères
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
  }

  # Pas de restriction géographique
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Certificat HTTPS par défaut de CloudFront (URL en xxxx.cloudfront.net)
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
