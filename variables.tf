variable "tenant" {
  type        = string
}

variable "VOLT_API_P12_FILE" {
  type        = string
}

variable "VES_P12_PASSWORD" {
  type        = string
  sensitive   = true
}

variable "namespace" {
  type        = string
}

variable "fqdn" {
  type = string
}

variable "namespace_create_timeout" {
  type    = string
  default = "10s"
}
