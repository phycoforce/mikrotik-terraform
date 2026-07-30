# Bridge

resource "routeros_interface_bridge" "br1" {
  name           = "BR1"
  protocol_mode  = "none"
  vlan_filtering = true

  lifecycle {
    prevent_destroy = true
  }
}

# Bridge ports

resource "routeros_interface_bridge_port" "ether1" {
  bridge    = routeros_interface_bridge.br1.name
  interface = routeros_interface_ethernet.ether1.name
  pvid      = 99
  comment   = "defconf"
}

resource "routeros_interface_bridge_port" "sfp_sfpplus2" {
  bridge      = routeros_interface_bridge.br1.name
  interface   = routeros_interface_ethernet.sfp_sfpplus2.name
  frame_types = "admit-only-vlan-tagged"

  lifecycle {
    prevent_destroy = true
  }
}

resource "routeros_interface_bridge_port" "sfp_sfpplus4" {
  bridge      = routeros_interface_bridge.br1.name
  interface   = routeros_interface_ethernet.sfp_sfpplus4.name
  pvid        = 20
  frame_types = "admit-only-untagged-and-priority-tagged"
}

resource "routeros_interface_bridge_port" "sfp_sfpplus5" {
  bridge    = routeros_interface_bridge.br1.name
  interface = routeros_interface_ethernet.sfp_sfpplus5.name
  pvid      = 20
}

resource "routeros_interface_bridge_port" "sfp_sfpplus6" {
  bridge    = routeros_interface_bridge.br1.name
  interface = routeros_interface_ethernet.sfp_sfpplus6.name
  pvid      = 20
}

resource "routeros_interface_bridge_port" "sfp_sfpplus7" {
  bridge    = routeros_interface_bridge.br1.name
  interface = routeros_interface_ethernet.sfp_sfpplus7.name
  pvid      = 20
}

resource "routeros_interface_bridge_port" "sfp_sfpplus8" {
  bridge      = routeros_interface_bridge.br1.name
  interface   = routeros_interface_ethernet.sfp_sfpplus8.name
  pvid        = 20
  frame_types = "admit-only-untagged-and-priority-tagged"
}

# Bridge VLANs (static entries only; VLANs 1 and 20 also exist as dynamic
# "added by pvid" rows and are intentionally not managed here)

resource "routeros_interface_bridge_vlan" "vlan10" {
  bridge   = routeros_interface_bridge.br1.name
  vlan_ids = ["10"]
  tagged   = [routeros_interface_ethernet.sfp_sfpplus2.name]
}

resource "routeros_interface_bridge_vlan" "vlan20" {
  bridge   = routeros_interface_bridge.br1.name
  vlan_ids = ["20"]
  tagged   = [routeros_interface_ethernet.sfp_sfpplus2.name]
}

resource "routeros_interface_bridge_vlan" "vlan30" {
  bridge   = routeros_interface_bridge.br1.name
  vlan_ids = ["30"]
  tagged   = [routeros_interface_ethernet.sfp_sfpplus2.name]
}

resource "routeros_interface_bridge_vlan" "vlan40" {
  bridge   = routeros_interface_bridge.br1.name
  vlan_ids = ["40"]
  tagged = [
    routeros_interface_ethernet.sfp_sfpplus2.name,
    routeros_interface_ethernet.sfp_sfpplus5.name,
    routeros_interface_ethernet.sfp_sfpplus6.name,
    routeros_interface_ethernet.sfp_sfpplus7.name,
  ]
}

# Management VLAN -- BR1 itself is tagged so BASE_VLAN stays reachable
resource "routeros_interface_bridge_vlan" "vlan99" {
  bridge   = routeros_interface_bridge.br1.name
  vlan_ids = ["99"]
  tagged = [
    routeros_interface_bridge.br1.name,
    routeros_interface_ethernet.sfp_sfpplus2.name,
    routeros_interface_ethernet.sfp_sfpplus5.name,
    routeros_interface_ethernet.sfp_sfpplus6.name,
    routeros_interface_ethernet.sfp_sfpplus7.name,
  ]

  lifecycle {
    prevent_destroy = true
  }
}
