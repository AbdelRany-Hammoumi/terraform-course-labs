# TODO: Expose module outputs
# - container_id (docker_container.app.id)
output "container_id" {
    value = docker_container.app.id
    description = "Container id"
}

# - container_name (docker_container.app.name)
output "container_name" {
    value = docker_container.app.name
    description = "Container name"
}

# - endpoint ("http://localhost:<external_port>")
output "endpoint" {
    value = "http://localhost:${var.external_port}"
    description = "Application URL"
}

# - config_path (local_file.config.filename)
output "config_path" {
    value = local_file.config.filename
    description = "Path to the generated config file"
}

output "image_id" {
    value = docker_image.app.image_id
}
