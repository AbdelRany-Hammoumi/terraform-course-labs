# TODO: Configure Terraform with required providers
# - kreuzwerker/docker ~> 3.0
# - hashicorp/local ~> 2.5
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

# TODO: Call the docker-app module for a "frontend" service
# - source: ./modules/docker-app
# - app_name: "frontend"
# - external_port: 8081
# - Pass the backend endpoint as an env var (API_URL)
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

# TODO: Call the docker-app module for a "backend" service
# - source: ./modules/docker-app
# - app_name: "backend"
# - external_port: 3000
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