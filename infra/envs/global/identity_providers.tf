locals {
  iam_identity_providers = {
    github = {
      oidc_provider_url       = "https://token.actions.githubusercontent.com"
      oidc_provider_client_id = "sts.amazonaws.com"
      oidc_provider_purpose   = "GitHub OIDC for deployment"
    }
  }
}

module "identity_providers" {
  for_each = local.iam_identity_providers
  source   = "../../modules/iam/identity_providers"

  oidc_provider_url       = each.value.oidc_provider_url
  oidc_provider_client_id = each.value.oidc_provider_client_id
  oidc_provider_purpose   = each.value.oidc_provider_purpose
}