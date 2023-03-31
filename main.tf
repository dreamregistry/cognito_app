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

resource "random_pet" "client_name" {}

resource "aws_cognito_user_pool_client" "client" {
  name = random_pet.client_name.id

  user_pool_id = var.cognito_user_pool_id

  generate_secret                      = true
  callback_urls                        = ["${var.root_url}${var.callback_path}"]
  logout_urls                          = ["${var.root_url}${var.logout_path}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]
}
