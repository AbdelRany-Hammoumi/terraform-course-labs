output "container_id" {
  description = "Container ID"
  value       = docker_container.app.id
}

output "container_name" {
  description = "Container name"
  value       = docker_container.app.name
}

output "endpoint" {
  description = "Application URL"
  value       = "http://localhost:${var.external_port}"
}

output "config_path" {
  description = "Path to the generated config file"
  value       = local_file.config.filename
}

output "image_id" {
  description = "Docker image ID"
  value       = docker_image.app.image_id
}