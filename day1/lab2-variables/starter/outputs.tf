output "config_filename" {
  value = local_file.config.filename
}

output "config_content" {
  value = jsondecode(local_file.config.content)
}

output "project_summary" {
  value = "${var.project_name} (${var.environment})"
}

output "read_back_content" {
  value = jsondecode(data.local_file.read_config.content)
}
