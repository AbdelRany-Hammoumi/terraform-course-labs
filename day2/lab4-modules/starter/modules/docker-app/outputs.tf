output container_id {
    description = "Container ID"
    value = docker_container.app.id
}


output container_name {
    value = docker_container.app.name
    description = "Container name"
}


output endpoint {
    value = "http://localhost:${var.external_port}"
    description = "Application URL"
}
# - config_path (local_file.config.filename)
output config_path {
    value = local_file.config.filename
    description = "Path to the generated config file"
}
