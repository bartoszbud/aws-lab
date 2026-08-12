resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url            = var.oidc_provider_url
  client_id_list = [var.oidc_provider_client_id]

  tags = {
    Purpose = var.oidc_provider_purpose
  }
}