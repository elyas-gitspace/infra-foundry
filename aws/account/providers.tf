provider "aws" {
  region = var.region

  # Tags appliqués à toutes les ressources de cette stack
  default_tags {
    tags = {
      Project   = "account"
      ManagedBy = "terraform"
      Repo      = "infra-foundry"
    }
  }
}
