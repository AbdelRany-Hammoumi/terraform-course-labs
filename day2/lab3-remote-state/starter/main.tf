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
	content = jsonencode({ "app": "lab3", "environment": "staging" })
	filename = "${path.module}/output/app-config.json"
}

resource "local_file" "info"{
    content = "Managed by Terraform — do not edit manually"
	filename = "${path.module}/output/metadata.txt"
}

resource "local_file" "cubit"{
    content = "Membres : Agathe, Clara, Antoine et Mélanie"
	filename = "${path.module}/output/cubit.txt"
}