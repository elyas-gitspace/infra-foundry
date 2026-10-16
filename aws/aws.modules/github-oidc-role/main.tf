# Module github-oidc-role : un rôle IAM que GitHub Actions peut "endosser" via OIDC.
# Pas d'access key à stocker : GitHub présente un jeton signé, AWS le vérifie
# et donne des credentials temporaires (valables ~1h) au workflow.

# Trust policy : QUI a le droit d'endosser le rôle
data "aws_iam_policy_document" "trust" {
  statement {
    sid     = "GitHubActionsOIDC"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    # Le jeton doit venir du fournisseur OIDC GitHub enregistré dans le compte
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    # Le jeton doit être destiné à AWS STS
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Et venir du bon repo / de la bonne branche (ex : repo:owner/repo:ref:refs/heads/main)
    # Sans ça, n'importe quel repo GitHub pourrait endosser le rôle !
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for s in var.allowed_subjects : "repo:${var.github_repo}:${s}"]
    }
  }
}

# Le rôle lui-même
resource "aws_iam_role" "this" {
  name                 = var.name
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600 # credentials valables 1h max
}

# Ce que le rôle a le droit de FAIRE (policy fournie par le projet appelant)
resource "aws_iam_role_policy" "this" {
  name   = "${var.name}-policy"
  role   = aws_iam_role.this.id
  policy = var.policy_json
}
