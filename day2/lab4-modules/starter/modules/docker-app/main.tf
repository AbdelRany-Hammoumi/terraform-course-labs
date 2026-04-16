resource "docker_image" "app" {
  name         = var.image
  keep_locally = true
}

resource "local_file" "config" {
  filename = "${path.module}/../../output/${var.app_name}-${var.environment}-config.json"
  content = jsonencode({
    app_name    = var.app_name
    environment = var.environment
    port        = var.external_port
  })
}



# TODO: Create a docker_container resource named "app"
# - name: "<app_name>-<environment>"
# - image: docker_image.app.image_id
# - ports: internal_port -> external_port
# - env: convert var.env_vars map to ["KEY=VALUE"] list

resource "docker_container" "app" {
    name = "${var.app_name}-${var.environment}"
    image = "${var.image}"

    ports {
        internal = var.internal_port
        external = var.external_port
    }

}
