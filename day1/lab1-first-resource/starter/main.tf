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

resource "local_file" "hello" {
    content = "Plus vite que le son!"
    filename = "${path.module}/hello.txt"
    file_permission = "0600"
}

resource "local_file" "manual" {
    filename = "${path.module}/output/manual.txt"
    content = "placeholder"

}


resource "local_file" "numbered" {
    count    = 3
    content  = "File number ${count.index + 1}"
    filename = "${path.module}/output/file-${count.index + 1}.txt"
}

resource "local_sensitive_file" "app_config" {

    filename = "app-config.json"
    content = jsonencode({
        version = "1.0"
        environement = "dev"
        services  = {
            api    = "https://api.example.com"
            db     = "postgresql://localhost:5432"
        }
    })

}