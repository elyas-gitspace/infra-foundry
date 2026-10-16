# Entrées du module github-oidc-role

variable "name" {
  description = "Nom du rôle IAM"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN du fournisseur OIDC GitHub (créé une fois par compte, stack aws/account)"
  type        = string
}

variable "github_repo" {
  description = "Repo GitHub autorisé, au format owner/repo"
  type        = string
}

variable "allowed_subjects" {
  description = "Ce qui est autorisé dans ce repo (branches, tags, environnements). Par défaut : seulement main"
  type        = list(string)
  default     = ["ref:refs/heads/main"]
}

variable "policy_json" {
  description = "Permissions du rôle (JSON, ex : data.aws_iam_policy_document.xxx.json)"
  type        = string
}
