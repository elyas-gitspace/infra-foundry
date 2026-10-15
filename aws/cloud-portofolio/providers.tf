provider "aws" {
  region = var.region

  # Tags applied to every resource of this stack
  default_tags {
    tags = {
      Project   = "cloud-portofolio"
      ManagedBy = "terraform"
      Repo      = "infra-foundry"
    }
  }
}
