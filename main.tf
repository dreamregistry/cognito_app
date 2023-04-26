terraform {
  backend "s3" {}

  required_providers {
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.4"
    }

    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "random" {}
provider "aws" {}

data "aws_region" "current" {}

locals {
  app_base_url = var.root_url != null ? var.root_url : "https://${var.domain_name_prefix}.${var.root_domain}"
}

resource "random_pet" "client_name" {}

resource "aws_cognito_user_pool_client" "client" {
  name = random_pet.client_name.id

  user_pool_id = var.cognito_user_pool_id

  generate_secret = true
  callback_urls   = ["${local.app_base_url}${var.callback_path}"]
  logout_urls     = [
    "${local.app_base_url}${var.logout_redirect_path}"
  ]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

locals {
  client_secret_parameter_key = "/cognito_app/${random_pet.client_name.id}/client_secret"
}

resource "terraform_data" "set_client_secret_parameter" {
  triggers_replace = [
    local.client_secret_parameter_key,
    var.cognito_user_pool_id,
    aws_cognito_user_pool_client.client.id
  ]
  provisioner "local-exec" {
    command = templatefile("${path.module}/create_client_secret_parameter.tpl", {
      parameterKey = local.client_secret_parameter_key,
      userPoolId   = var.cognito_user_pool_id,
      clientId     = aws_cognito_user_pool_client.client.id,
    })
  }

  provisioner "local-exec" {
    when    = destroy
    command = templatefile("${path.module}/delete_client_secret_parameter.tpl", {
      parameterKey = self.triggers_replace[0],
    })
  }
}
