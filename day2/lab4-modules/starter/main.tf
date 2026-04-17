terraform {
  required_version = ">= 1.6"

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

provider "docker" {}
provider "local" {}


module "frontend" {
  source = "./modules/docker-app"

  app_name      = "frontend"
  environment   = var.environment
  image         = "nginx:1.25-alpine"
  external_port = 8081
  env_vars = {
    API_URL = module.backend.endpoint
  }
}

module "backend" {
  source = "./modules/docker-app"

  app_name      = "backend"
  environment   = var.environment
  image         = "nginx:1.25-alpine"
  external_port = 3000
  env_vars = {
    LOG_LEVEL = "debug"
  }
}
