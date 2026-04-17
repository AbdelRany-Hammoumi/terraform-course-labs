# This file declares which providers the module needs.
# Without it, Terraform assumes "hashicorp/docker" (which doesn't exist).
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
