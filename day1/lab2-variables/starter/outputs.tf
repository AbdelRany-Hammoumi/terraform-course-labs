# TODO: see lab README
locals {
  decodedJSON = "${jsondecode(local_file.config.content)}"
}

output "config_filename" {
    description = "i guess the name of the config file"
    value       = "${data.local_file.read_config.filename}"
}

output "config_content" {
    description = "the decoded json content of file_config (using jsondecode())"
    value       = local.decodedJSON
    sensitive = true
}

output "project_summary" {
    description = "project name and env"
    value = format(
        "%s - %s",
        local.decodedJSON.project_name,
        local.decodedJSON.environment
    )
    sensitive = true
}

output "read_back_content" {
    description = "read data using jsondecode()"
    value       = local.decodedJSON
    sensitive   = true
}