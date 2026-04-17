# TODO: Configure Terraform with required providers
# - kreuzwerker/docker ~> 3.0
# - hashicorp/local ~> 2.5

# TODO: Call the docker-app module for a "frontend" service
# - source: ./modules/docker-app
# - app_name: "frontend"
# - external_port: 8080
# - Pass the backend endpoint as an env var (API_URL)

# TODO: Call the docker-app module for a "backend" service
# - source: ./modules/docker-app
# - app_name: "backend"
# - external_port: 3000
