provider "aws" {
  region = var.region

  # Tags applied to every resource of this stack
  default_tags {
    tags = {
      Project   = "pgkube-guard"
      ManagedBy = "terraform"
      Repo      = "infra-foundry"
    }
  }
}
