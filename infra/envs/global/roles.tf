locals {
  iam_roles = {
    github_actions = {
      role_name           = "GitHubOIDCRole"
      assume_role_policy  = data.aws_iam_policy_document.github_actions_assume_role_policy.json
      managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      tags = {
        Description = "Role for GitHub Actions to assume via OIDC"
      }
    }
  }
}

module "roles" {
  for_each            = local.iam_roles
  source              = "../../modules/iam/roles"
  role_name           = each.value.role_name
  assume_role_policy  = each.value.assume_role_policy
  managed_policy_arns = each.value.managed_policy_arns
  tags                = each.value.tags

  depends_on = [module.identity_providers]
}

#trust_policies
data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type        = "Federated"
      identifiers = [module.identity_providers["github"].oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${module.identity_providers["github"].oidc_provider_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "${module.identity_providers["github"].oidc_provider_url}:sub"
      values   = ["repo:bartoszbud@38439280/aws-lab@1332102599:*"]
    }
  }
}