variable "environment" {
    type = string
    default= "dev"
    description = "Deployment"
}


variable "app_name" {
    type = string
    default = "The alleged App"
    description = "Name of the application"
}

variable "image" {
    type = string
    default ="nginx:1.25-alpine"
    description = "Docker image to use"
}

variable "internal_port" {
    type = number
    default = 80
    description = "Port exposed inside the container"
}

variable "external_port" {
    type = number
    default = 8000
    description = "Port mappped on the host"
}

variable "env_vars" {
    type= map(string)
    default = {}
    description = "Environement variables to pass to the container"
}
