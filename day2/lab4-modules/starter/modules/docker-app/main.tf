# TODO: Create a docker_image resource named "app"
# - name: var.image
# - keep_locally: true

# TODO: Create a local_file resource named "config"
# - filename: output/<app_name>-<environment>-config.json
# - content: JSON with app_name, environment, port

# TODO: Create a docker_container resource named "app"
# - name: "<app_name>-<environment>"
# - image: docker_image.app.image_id
# - ports: internal_port -> external_port
# - env: convert var.env_vars map to ["KEY=VALUE"] list
