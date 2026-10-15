# Entrées du module s3-bucket

variable "bucket_name" {
  description = "Nom du bucket (doit être unique dans tout AWS)"
  type        = string
}

variable "force_destroy" {
  description = "Autorise terraform destroy même s'il reste des fichiers dans le bucket (pratique pour un bucket de test)"
  type        = bool
  default     = false
}

variable "abort_incomplete_upload_days" {
  description = "Nombre de jours avant de supprimer un upload multipart non terminé"
  type        = number
  default     = 1
}
