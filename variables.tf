## Provider configuration
variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "mongodbatlas_public_key" {
  type = string
  description = "(Required) MongoDB Atlas public key"
}

variable "mongodbatlas_private_key" {
  type = string
  description = "(Required) MongoDB Atlas private key"
}

## Atlas variables
variable "organization_id" {
  type = string
  description = "(Required) MongoDB Atlas organization ID"
}

variable "project_name" {
  type = string
  description = "(Required) MongoDB Atlas project name"
}

variable "whitelist_cidr" {
  type = string
  description = "(Required) CIDR whitelist entry"
  default = "0.0.0.0"
}

variable "db_password" {
  type = string
  description = "(Required) Database user password"
  default = "Santander123"
}

variable "auth_database_name" {
  type = string
  description = "(Optional) Authentication database name"
  default = "admin"
}

variable "region" {
  type = string
  default = "westeurope"
}