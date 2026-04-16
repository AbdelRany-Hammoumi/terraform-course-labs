terraform {
  required_version = ">= 1.6"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "hello" {
  content  = "Hello from Terraform!"
  filename = "${path.module}/hello.txt"
}

resource "local_file" "app_config" {
  filename = "${path.module}/app-config.json"
  content = jsonencode({
    version     = "1.0.0"
    environment = "dev"
    services = {
      api = "enabled"
      db  = "postgres"
    }
  })
}
