provider "volterra" {
  api_p12_file     = var.VOLT_API_P12_FILE
  url              = "https://${var.tenant}.console.ves.volterra.io/api"
}
