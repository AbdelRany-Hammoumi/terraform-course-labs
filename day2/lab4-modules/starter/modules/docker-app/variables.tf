variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "image" {
  description = "Docker image to use"
  type        = string
  default     = "nginx:1.25-alpine"
}

variable "internal_port" {
  description = "Port exposed inside the container"
  type        = number
  default     = 80
}

variable "external_port" {
  description = "Port mapped on the host"
  type        = number
}

variable "env_vars" {
  description = "Environment variables to pass to the container"
  type        = map(string)
  default     = {}
}
