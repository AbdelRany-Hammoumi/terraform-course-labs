# TODO: Define module input variables
# - app_name (string, required)
variable "app_name" {
    description = "Name of the application"
    type = string
}

# - environment (string, default "dev")
variable "environment" {
    description = "Deployment environment"
    type = string
    default = "dev"
}

# - image (string, default "nginx:1.25-alpine")
variable "image" {
    description = "Docker image to use"
    type = string
    default = "nginx:1.25-alpine"
}

# - internal_port (number, default 80)
variable "internal_port" {
    description = "Port exposed inside the container"
    type = number
    default = 80
}

# - external_port (number, required)
variable "external_port" {
    description = "Port mapped on the host"
    type = number
}

# - env_vars (map(string), default {})
variable "env_vars" {
    description = "Environment variables to pass to the container"
    type = map(string)
    default = {}
}