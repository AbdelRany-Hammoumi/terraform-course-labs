# Provider configuration
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

# 3 — Resource using variables
resource "local_file" "config" {
  filename = "${path.module}/output/${var.project_name}-${var.environment}.json"
  content = jsonencode({
    project     = var.project_name
    environment = var.environment
    tags        = var.tags
  })
}

# 6 — Data source: read back the file
data "local_file" "read_config" {
  filename = local_file.config.filename
}
