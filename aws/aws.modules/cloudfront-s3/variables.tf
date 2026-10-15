# Entrées du module cloudfront-s3

variable "name" {
  description = "Nom de l'OAC et commentaire de la distribution"
  type        = string
}

variable "bucket_id" {
  description = "Nom du bucket S3 d'origine"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "Domaine régional du bucket (output regional_domain_name du module s3-bucket)"
  type        = string
}

variable "default_root_object" {
  description = "Fichier servi à la racine du site"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Zones géographiques servies. PriceClass_100 = Europe + Amérique du Nord (le moins cher)"
  type        = string
  default     = "PriceClass_100"
}
