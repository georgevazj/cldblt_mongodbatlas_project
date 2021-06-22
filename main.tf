terraform {
  required_version = ">=0.13.5"
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  version = "2.30.0"
  features {}

  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
}

locals {
  cluster_name = "${var.project_name}${var.region}"
}

provider "mongodbatlas" {
  public_key = var.mongodbatlas_public_key
  private_key  = var.mongodbatlas_private_key
}

## MongoDB Atlas project
resource "mongodbatlas_project" "project" {
  name = var.project_name
  org_id = var.organization_id
}

resource "mongodbatlas_project_ip_whitelist" "whitelist" {
  project_id = mongodbatlas_project.project.id
  cidr_block = var.whitelist_cidr
  comment = var.project_name

  depends_on = [mongodbatlas_project.project]
}

## Database user
resource "mongodbatlas_database_user" "dbUser" {
  project_id = mongodbatlas_project.project.id
  username = var.project_name
  password = var.db_password
  auth_database_name = var.auth_database_name

  roles {
    role_name     = "readWrite"
    database_name = "dbforApp"
  }

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "project"
    value = var.project_name
  }

  # scopes {
  #  name   = local.cluster_name
  #  type = "CLUSTER"
  # }

  depends_on = [mongodbatlas_project.project]
}

resource "mongodbatlas_cluster" "cluster" {
  name = local.cluster_name
  project_id = mongodbatlas_project.project.id
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "EUROPE_WEST"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  //Provider Settings "block"
  provider_name               = "AZURE"
  provider_disk_type_name     = "P6"
  provider_instance_size_name = "M10"

  depends_on = [mongodbatlas_project.project]
}

resource "mongodbatlas_privatelink_endpoint" "endpoint" {
  project_id    = mongodbatlas_project.project.id
  provider_name = "AZURE"
  region        = "westeurope"

  depends_on = [mongodbatlas_cluster.cluster]
}