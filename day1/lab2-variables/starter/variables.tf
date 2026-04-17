# TODO: see lab README
variable "project_name" {
    description = "the project's name"
    type = string
    default = "my-terraform-lab"
}

variable "environment" {
    description = "the project's environment"
    type = string
    default = "dev"

    validation {
        condition     = contains(["dev", "staging", "prod"], var.environment)
        error_message = "Environment must be dev, staging, or prod."
    }
}

variable "tags" {
    description = "the project's tags"
    type = map(string)
    default = {}
}

variable "file_count" {
    description = "number of files in the project i guess"
    type = number
    default = 1
}

variable "api_key" {
    sensitive = true
    default = "yo"
}

variable "app_config" {
  type = object({
    name    = string
    port    = number
    enabled = bool
  })
  default = {name= "david", port="1234", enabled=false}
}