# Firewall address lists
# Two lists, 12 static rows total. Every row is enabled and has no timeout, so
# only address/list/comment are expressed. dynamic and creation_time are
# read-only. No dynamic:true rows exist in this menu on the live device.
#
# Addresses are literals rather than references: the k8s LoadBalancer VIPs
# (10.0.20.244-250) are allocated by MetalLB/kube-vip in the cluster, not by
# anything in this configuration, and the two Kindle addresses come from the
# DHCP leases in dhcp.tf but the firewall rows are independent of them.

# k8s-cluster — the Kubernetes nodes plus their in-cluster service VIPs.
# Referenced by the firewall filter/NAT rules (a later migration wave).

resource "routeros_ip_firewall_addr_list" "k8s_logos" {
  list    = "k8s-cluster"
  address = "10.0.20.2"
  comment = "logos"
}

resource "routeros_ip_firewall_addr_list" "k8s_ontos" {
  list    = "k8s-cluster"
  address = "10.0.20.3"
  comment = "ontos"
}

resource "routeros_ip_firewall_addr_list" "k8s_pneuma" {
  list    = "k8s-cluster"
  address = "10.0.20.4"
  comment = "pneuma"
}

resource "routeros_ip_firewall_addr_list" "k8s_aionios" {
  list    = "k8s-cluster"
  address = "10.0.20.10"
  comment = "aionios"
}

resource "routeros_ip_firewall_addr_list" "k8s_owncast_ingress" {
  list    = "k8s-cluster"
  address = "10.0.20.244"
  comment = "owncast-ingress"
}

resource "routeros_ip_firewall_addr_list" "k8s_plex" {
  list    = "k8s-cluster"
  address = "10.0.20.245"
  comment = "Plex"
}

resource "routeros_ip_firewall_addr_list" "k8s_postgres" {
  list    = "k8s-cluster"
  address = "10.0.20.246"
  comment = "postgres"
}

resource "routeros_ip_firewall_addr_list" "k8s_external_ingress" {
  list    = "k8s-cluster"
  address = "10.0.20.247"
  comment = "external-ingress"
}

resource "routeros_ip_firewall_addr_list" "k8s_internal_ingress" {
  list    = "k8s-cluster"
  address = "10.0.20.249"
  comment = "internal-ingress"
}

resource "routeros_ip_firewall_addr_list" "k8s_kube_vip" {
  list    = "k8s-cluster"
  address = "10.0.20.250"
  comment = "kube-vip"
}

# kindles — the two UNTRUSTED_VLAN Kindles, pinned by the static DHCP leases in
# dhcp.tf (10.0.30.15 / 10.0.30.18).

resource "routeros_ip_firewall_addr_list" "kindles_aaron" {
  list    = "kindles"
  address = "10.0.30.15"
  comment = "Aaron's Kindle"
}

resource "routeros_ip_firewall_addr_list" "kindles_alex" {
  list    = "kindles"
  address = "10.0.30.18"
  comment = "Alex's Kindle"
}

# k8s-nodes — ONLY the three node addresses (no VIPs). Added 2026-07-30 for
# the ExternalDNS REST-API input rule: the webhook provider pods egress with
# the node address, and being narrower than k8s-cluster keeps the router API
# closed to traffic sourced from the LoadBalancer VIP range.
resource "routeros_ip_firewall_addr_list" "k8s_nodes_logos" {
  list    = "k8s-nodes"
  address = "10.0.20.2"
  comment = "logos"
}

resource "routeros_ip_firewall_addr_list" "k8s_nodes_ontos" {
  list    = "k8s-nodes"
  address = "10.0.20.3"
  comment = "ontos"
}

resource "routeros_ip_firewall_addr_list" "k8s_nodes_pneuma" {
  list    = "k8s-nodes"
  address = "10.0.20.4"
  comment = "pneuma"
}
