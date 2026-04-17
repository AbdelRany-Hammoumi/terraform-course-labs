# TODO: see lab README

resource "local_file" "config" {
  filename = "${path.module}/${var.project_name}-config-${var.environment}.json"
  content  = jsonencode({
    version     = "1.0.0"
    project_name = "${var.project_name}"
    environment = "${var.environment}"
    tags = "${var.tags}"
    api_key = var.api_key
  })
}

data "local_file" "read_config" {
  filename = local_file.config.filename
}

resource "local_file" "complex_config" {
  filename = "config.json"

  content = jsonencode(var.app_config)
}