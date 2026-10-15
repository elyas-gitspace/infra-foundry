# Le module a besoin du provider AWS (fourni par le projet qui l'appelle)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
