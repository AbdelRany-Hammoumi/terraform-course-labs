variable "project_name" {
  type    = string
  default = "my-terraform-lab"
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "file_count" {
  type    = number
  default = 1
}
