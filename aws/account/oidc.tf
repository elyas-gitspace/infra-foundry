# Stack "account" : ressources partagées par tous les projets, créées une seule fois par compte AWS.

# Fournisseur OIDC GitHub : dit à AWS "je fais confiance aux jetons signés par GitHub Actions".
# Tous les rôles GitHub (cloud-portofolio, futurs projets...) s'appuient dessus.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"] # l'audience attendue dans le jeton
  # Pas de thumbprint : AWS vérifie lui-même le certificat de GitHub
}

# Le fournisseur existait déjà dans le compte (créé à la main lors d'anciens tests).
# Ce bloc dit à Terraform : "ne le crée pas, prends le contrôle de celui qui existe".
# Une fois l'apply passé, ce bloc ne sert plus à rien : tu peux le supprimer.
data "aws_caller_identity" "current" {}

import {
  to = aws_iam_openid_connect_provider.github
  id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}
