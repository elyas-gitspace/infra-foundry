# Module iam-user : un utilisateur IAM "technique" (pour une app, pas un humain)
# avec une policy inline et une access key.

# L'utilisateur IAM
resource "aws_iam_user" "this" {
  name = var.name
  path = var.path # sert à ranger les users par projet, ex : /pgkube-guard/
}

# Ses permissions : la policy JSON est fournie par le projet appelant
resource "aws_iam_user_policy" "this" {
  name   = var.policy_name
  user   = aws_iam_user.this.name
  policy = var.policy_json
}

# Sa clé d'accès (access key id + secret), utilisée par l'app pour s'authentifier.
# Attention : le secret est stocké dans le state Terraform, ne jamais le committer.
resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
