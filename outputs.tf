output "COGNITO_CLIENT_ID" {
  value     = aws_cognito_user_pool_client.client.id
}

output "COGNITO_CLIENT_SECRET" {
  value = {
    type   = "ssm"
    key    = local.client_secret_parameter_key
    region = data.aws_region.current.name
  }
}

output "COGNITO_ISSUER_URL" {
  value     = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${var.cognito_user_pool_id}"
}

output "COGNITO_DISCOVERY_URL" {
  value     = "https://cognito-idp.${data.aws_region.current.name}.amazonaws.com/${var.cognito_user_pool_id}/.well-known/openid-configuration"
}

output "COGNITO_LOGOUT_URL" {
  value     = "${var.cognito_user_pool_domain}/logout"
}

output "COGNITO_LOGOUT_REDIRECT_URL" {
  value = tolist(aws_cognito_user_pool_client.client.logout_urls)[0]
}

output "COGNITO_CALLBACK_URL" {
  value = tolist(aws_cognito_user_pool_client.client.callback_urls)[0]
}