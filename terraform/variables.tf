
variable "location" {
  type    = string
  default = "centralindia"
}

variable "prefix" {
  type    = string
  default = "fastapi"
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "kvfastapi-${random_string.suffix.result}"
}

variable "docker_image" {
  description = "Docker Hub repository, e.g. youruser/imagename"
  type        = string
  default     = "asa-assignment/fastapi"
}

variable "docker_tag" {
  description = "Image tag"
  type        = string
  default     = "latest"
}