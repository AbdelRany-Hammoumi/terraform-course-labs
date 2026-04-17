# TODO: see lab README
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
    filename = "${path.module}/output/app-config.json"
    content = jsonencode({
        app = "lab3"
        environment = "staging"
    })
}

resource "local_file" "info" {
    filename = "${path.module}/output/metadata.txt"
    content = "Managed by Terraform — do not edit manually"
}

resource "local_file" "easter_egg" {
    filename = "${path.module}/output/surprise.txt"
    content = "WE'RE NO STRANGERS TO LOOOOOVE YOU KNOW THE RULES AND SO DO IIII"
}

resource "local_file" "manual" {
  filename = "manual.txt"
  content  = "manual"
}