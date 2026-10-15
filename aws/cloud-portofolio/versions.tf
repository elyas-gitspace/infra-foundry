terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # State stored in S3, shared between your Mac and GitHub Actions
  backend "s3" {
    bucket       = "infra-foundry-tfstate"
    key          = "aws/cloud-portofolio/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    use_lockfile = true # S3-native lock, no DynamoDB table needed
  }
}
