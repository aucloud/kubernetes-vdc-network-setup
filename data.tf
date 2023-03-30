

data "vcd_org_vdc" "nsxt_vdc" {
  name = var.vdc
  org  = var.org
}

data "vcd_nsxt_edgegateway" "edge_gateway" {
  owner_id = data.vcd_org_vdc.nsxt_vdc.id
  name     = var.edge_gateway
}
