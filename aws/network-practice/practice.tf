# =============================================================================
# Lab réseau AWS (network-practice)
# Ressources supprimées : le prochain apply de la CI détruit tout sur AWS.
# Pour refaire un exo : remettre les ressources ici (voir l'historique Git).
# =============================================================================

# Région AWS (utilisée par providers.tf, à garder même quand le lab est vide)
variable "region" {
  type    = string
  default = "eu-west-3" # Paris
}
