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

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_vsite_refs_namespace" {
  type = string
}

variable "f5xc_virtual_k8s_namespace" {
  type = string
}

variable "f5xc_vk8s_name" {
  type = string
}

variable "f5xc_vk8s_description" {
  type    = string
  default = ""
}

variable "f5xc_vk8s_isolated" {
  type    = bool
  default = false
}

variable "f5xc_vk8s_default_flavor_name" {
  type    = string
  default = ""
}

variable "f5xc_virtual_site_refs" {
  type    = list(string)
  default = []
}

variable "f5xc_create_k8s_creds" {
  type    = bool
  default = false
}

variable "f5xc_k8s_credentials_name" {
  type    = string
  default = ""
}

variable "f5xc_labels" {
  type    = map(string)
  default = {}
}

variable "is_sensitive" {
  type        = bool
  default     = false
  description = "Whether to mask sensitive data in output or not"
}

variable "f5xc_api_credential_expiry_days" {
  type    = number
  default = 10
}
