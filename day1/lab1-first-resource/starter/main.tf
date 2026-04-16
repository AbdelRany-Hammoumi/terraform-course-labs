# 2 — Configure the provider
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

# 3 — First resource: hello.txt
resource "local_file" "hello" {
  content  = "Hello from Terraform! — mise à jour Step 6"
  filename = "${path.module}/hello.txt"
}

# 7 — Second resource: app-config.json
resource "local_file" "app_config" {
  filename = "${path.module}/app-config.json"
  content = jsonencode({
    version     = "1.0.0"
    environment = "dev"
    services = {
      api     = "http://localhost:8080"
      database = "postgres://localhost:5432/mydb"
    }
  })
}
