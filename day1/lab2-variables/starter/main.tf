# TODO: see lab README
terraform {
    required_version = ">= 1.6"

    required_providers {
        local = {
            source = "hashicorp/local"
            version = "~> 2.5"
        }
    }

}

provider "local" {
        
}

resource "local_file" "config" {

    filename = join("-",[var.project_name, var.environment])

    content = jsonencode({
        project_name = var.project_name
        environment = var.environment
        tags = var.tags

    })

}

data "local_file" "read_config" {
  filename = local_file.config.filename
}