terraform {
  required_version = ">= 1.6"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "app_config" {
  filename = "output/app-config.json"
  content  = jsonencode({
    app         = "lab3"
    environment = "staging"
  })
}

resource "local_file" "info" {
  filename = "output/metadata.txt"
  content  = "Managed by Terraform — do not edit manually"
}
