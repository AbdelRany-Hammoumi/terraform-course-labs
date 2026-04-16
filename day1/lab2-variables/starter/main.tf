# TODO: see lab README

resource "local_file" "config" {
  filename = "${path.module}/${var.project_name}-config-${var.environment}.json"
  content  = jsonencode({
    version     = "1.0.0"
    project_name = "${var.project_name}"
    environment = "${var.environment}"
    tags = "${var.tags}"
  })
}

data "local_file" "read_config" {
  filename = local_file.config.filename
}