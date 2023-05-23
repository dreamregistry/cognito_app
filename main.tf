terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {}

data "aws_region" "current" {}

locals {
  app_base_url = var.root_url != null ? var.root_url : "https://${var.domain_prefix}.${var.domain_suffix}"
}

module "cognito_app" {
  source                   = "github.com/hereya/terraform-modules//cognito-app/module?ref=v0.16.0"
  app_base_url             = local.app_base_url
  cognito_user_pool_domain = var.cognito_user_pool_domain
  cognito_user_pool_id     = var.cognito_user_pool_id
  callback_path            = var.callback_path
  logout_redirect_path     = var.logout_redirect_path
}
