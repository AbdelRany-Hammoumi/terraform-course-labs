# TODO: see lab README
output "config_filename" {
    description = "i guess the name of the config file"
    value       = "${data.local_file.read_config.filename}"
}

output "config_content" {
    description = "the decoded json content of file_config (using jsondecode())"
    value       = "${jsondecode(local_file.config.content)}"
}

output "project_summary" {
    description = "project name and env"
    value = format(
        "%s - %s",
        jsondecode(local_file.config.content).project_name,
        jsondecode(local_file.config.content).environment
    )
}

output "read_back_content" {
    description = "read data using jsondecode()"
    value       = "${jsondecode(data.local_file.read_config.content)}"
}