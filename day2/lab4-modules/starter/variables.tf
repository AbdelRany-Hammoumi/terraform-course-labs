# TODO: Define a variable for the deployment environment
# - type: string
# - default: "dev"
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}