# TODO: see lab README

output "config_filename" {

    description = "the path to the generated file"
    value   = "${local_file.config.filename}"
    sensitive = true

}

output "config_content" {

    description = "read the Json content"
    value = jsondecode(resource.local_file.config.content)

}

output "project_summary" {
    description = "combinaison du nom de projet et de l'environement"
    
    value = join("-",[var.project_name, var.environment])
  
}

output "read_back_content"{
    description = "jsondecode de datasource"
    value = jsondecode(data.local_file.read_config.content)
}