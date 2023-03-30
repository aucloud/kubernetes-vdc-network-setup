terraform {
  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = "3.8.2"
    }
  }
}

provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  org                  = var.org
  url                  = var.url
  vdc                  = var.vdc
  max_retry_timeout    = "240"
  allow_unverified_ssl = "true"

}
