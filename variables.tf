variable "cognito_user_pool_id" {
  type        = string
  description = "The name of the user pool to create the app client in"
}

variable "cognito_user_pool_domain" {
  type        = string
  description = "The fully-qualified domain name of the user pool"
}

variable "root_url" {
  type        = string
  description = "Application root url"
}

variable "callback_path" {
  type        = string
  description = "Application callback path for authorization code grant"
  default     = "/auth/callback"
}

variable "logout_path" {
  type        = string
  description = "Application logout path"
  default     = "/auth/logout"
}