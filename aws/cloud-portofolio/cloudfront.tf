# CDN qui sert le site aux visiteurs, en HTTPS, depuis le bucket privé (accès via OAC)
module "site_cdn" {
  source = "../aws.modules/cloudfront-s3"

  name                        = "cloud-portofolio"
  bucket_id                   = module.site_bucket.id
  bucket_regional_domain_name = module.site_bucket.regional_domain_name
}
