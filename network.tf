

resource "vcd_nsxt_app_port_profile" "k8sapi" {

  name        = "k8sapi"
  description = "Application port profile kubenetes api, with TKG"
  scope = "TENANT"

  app_port {
    protocol = "TCP"
    port     = ["6443"]
  }
  lifecycle {
    prevent_destroy = false
  }
}

/* IP Sets are groups of objects to which the firewall rules apply */
resource "vcd_nsxt_ip_set" "kubenet_ips" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  name            = "kubenetworkips"
  description     = "IP Set for kube network"
  ip_addresses    = ["${var.k8s_24_network}.1/24"]
}


/* IP Sets are groups of objects to which the firewall rules apply */
resource "vcd_nsxt_ip_set" "kube_vip" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id
  name            = "kubevipip"
  description     = "IP set for kube vip"
  ip_addresses    = [var.k8s_api_vs_ip]
}



resource "vcd_network_routed_v2" "kubenet" {
  org         = var.org
  name        = "kubernetes-network"
  description = "kubernetes network"

  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  gateway       = "${var.k8s_24_network}.1"
  prefix_length = 24

}

resource "vcd_nsxt_network_dhcp" "kubenet" {
  org_network_id = vcd_network_routed_v2.kubenet.id

  pool {
    # Pool range is arbitrary
    start_address = "${var.k8s_24_network}.5"
    end_address   = "${var.k8s_24_network}.250"
  }
  dns_servers = [
    "1.1.1.1",
  "9.9.9.9"]
}

resource "vcd_nsxt_firewall" "firewalls" {

  org             = var.org
  edge_gateway_id = data.vcd_nsxt_edgegateway.edge_gateway.id

  // Support SNAT for kubernetes nodes to access resources on the internet //
  rule {
    name        = "kubenet to internet"
    direction   = "OUT"
    action      = "ALLOW"
    source_ids  = [vcd_nsxt_ip_set.kubenet_ips.id]
    ip_protocol = "IPV4"
  }

  /* Internet to public IP */
  rule {
    name                 = "Internet-to-k8s api and reverse"
    direction            = "IN_OUT"
    action               = "ALLOW"
    destination_ids      = [vcd_nsxt_ip_set.kube_vip.id]
    app_port_profile_ids = [vcd_nsxt_app_port_profile.k8sapi.id]
    ip_protocol          = "IPV4"
  }
  rule {
    name        = "public IP to k8s subnet"
    direction   = "IN_OUT"
    action      = "ALLOW"
    source_ids  = [vcd_nsxt_ip_set.kubenet_ips.id]
    destination_ids = [vcd_nsxt_ip_set.kube_vip.id]
    ip_protocol = "IPV4"
  }

} 
