variable "region" {
  description = "Région AWS du bucket (CloudFront, lui, est global)"
  type        = string
  default     = "eu-west-3"
}

variable "bucket_name" {
  description = "Nom du bucket qui contient les fichiers du site (unique dans tout AWS)"
  type        = string
  default     = "cloud-portofolio-site-elyas"
}

variable "github_repo" {
  description = "Repo GitHub du site, autorisé à déployer (owner@id/repo@id, format du sub OIDC GitHub)"
  type        = string
  default     = "elyas-gitspace@230582305/cloud-portofolio@1420671260"
}
