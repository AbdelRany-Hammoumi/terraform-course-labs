terraform {
    required_version = ">= 1.6"

    required_providers {
        local = {
            source = "hashicorp/local"
            version = "~> 2.5"
        }
    }

}

terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}

resource "local_file" "app_config"{
    filename =  "output/app-config.json"
    content = jsonencode({
        app = "lab3"
        environement = "staging"
    })
}

resource "local_file" "text" {
    filename = "output/step7.txt"
    content = "Pour la step7"
}

resource "local_file" "info" {
    filename = "output/info.txt"
    content = "Managed by Terraform — do not edit manually"
  
}