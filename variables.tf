
variable "vcd_user" {
    # User in VCD typically for AUCloud a numeric identifier such as 100.1
    type = string
}
variable "vcd_pass" {
    # pass in via an envar. Do not commit.
    type = string
    sensitive = true
}
variable "url" {
  type    = string
  # Currently set for AUCloud EDCE in BSZ
  default = "https://api-vcd-sz101.portal.australiacloud.com.au/api"
}
variable "vdc" {
  type = string
}

variable "org" {
  # VCD ORG name
  type = string
  default = ""
}
variable "edge_gateway" {
  # VCD NSX-T edge gateway name
  type = string
}

variable "k8s_api_vs_ip" {
  # From your public allocation. Will need to be matched as the k8s api IP in cluster provisioner
  default = ""
}

variable "k8s_SNAT_IP" {
  # Another public IP. Virtual services IPs cannot act directly as an SNAT. Required to pull packages.
  default = ""
}

variable "k8s_24_network" {
  # this network is an arbitrary private IP address space. it has to be /24 sized for this code/
  default = "10.100.1"
}
