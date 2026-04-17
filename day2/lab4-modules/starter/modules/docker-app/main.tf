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

resource "docker_container" "app" {
  name  = "${var.app_name}-${var.environment}"
  image = docker_image.app.image_id

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  env = [for k, v in var.env_vars : "${k}=${v}"]
}
