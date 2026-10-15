# Entrées du module iam-user

variable "name" {
  description = "Nom de l'utilisateur IAM"
  type        = string
}

variable "path" {
  description = "Chemin IAM pour regrouper les users (ex : /mon-projet/)"
  type        = string
  default     = "/"
}

variable "policy_name" {
  description = "Nom de la policy inline attachée au user"
  type        = string
}

variable "policy_json" {
  description = "Contenu JSON de la policy (ex : data.aws_iam_policy_document.xxx.json)"
  type        = string
}
