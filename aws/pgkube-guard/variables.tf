variable "region" {
  description = "AWS region of the bucket"
  type        = string
  default     = "eu-west-3"
}

variable "bucket_name" {
  description = "Globally unique name of the backup bucket"
  type        = string
  default     = "pgkube-guard-backups-elyas-test"
}

variable "prefix" {
  description = "Folder inside the bucket where dumps are stored (must match S3_PREFIX in pgkube-guard)"
  type        = string
  default     = "pgkube-guard/"
}
