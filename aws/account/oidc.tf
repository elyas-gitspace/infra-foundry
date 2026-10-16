# Stack "account" : ressources partagées par tous les projets, créées une seule fois par compte AWS.

# Fournisseur OIDC GitHub : dit à AWS "je fais confiance aux jetons signés par GitHub Actions".
# Tous les rôles GitHub (cloud-portofolio, futurs projets...) s'appuient dessus.
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"] # l'audience attendue dans le jeton
  # Pas de thumbprint : AWS vérifie lui-même le certificat de GitHub
}

