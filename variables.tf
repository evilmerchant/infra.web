variable "environment" {
  type = string
  validation {
    condition     = contains(["nonprod", "prod"], var.environment)
    error_message = "Allowed values: (nonprod, prod)."
  }
  default = "prod"
}

variable "project" {
  type    = string
}

variable "name" {
  type    = string
}


variable "location" {
  type    = string
}

locals {
  projectTags = {
    "project" : var.project,
    "app" : var.name
  }
}

variable "domain" {
  type    = string
}

variable "subdomain" {
  type = string  
}
