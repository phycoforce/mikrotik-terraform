# Ethernet interfaces
# Physical ports exist in hardware; they are imported and only updated.
# Non-defaults: l2mtu=9084 (jumbo frames) on every port, plus comments on
# sfp-sfpplus2 (Uplink), 4 (ontos), 5 (logos), 6 (pneuma).

resource "routeros_interface_ethernet" "ether1" {
  factory_name = "ether1"
  name         = "ether1"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus1" {
  factory_name = "sfp-sfpplus1"
  name         = "sfp-sfpplus1"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus2" {
  factory_name = "sfp-sfpplus2"
  name         = "sfp-sfpplus2"
  comment      = "Uplink"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus3" {
  factory_name = "sfp-sfpplus3"
  name         = "sfp-sfpplus3"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus4" {
  factory_name = "sfp-sfpplus4"
  name         = "sfp-sfpplus4"
  comment      = "ontos"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus5" {
  factory_name = "sfp-sfpplus5"
  name         = "sfp-sfpplus5"
  comment      = "logos"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus6" {
  factory_name = "sfp-sfpplus6"
  name         = "sfp-sfpplus6"
  comment      = "pneuma"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus7" {
  factory_name = "sfp-sfpplus7"
  name         = "sfp-sfpplus7"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus8" {
  factory_name = "sfp-sfpplus8"
  name         = "sfp-sfpplus8"
  l2mtu        = 9084
}

# Interface list

resource "routeros_interface_list" "base" {
  name = "BASE"
}

resource "routeros_interface_list_member" "base_vlan" {
  interface = routeros_interface_vlan.base_vlan.name
  list      = routeros_interface_list.base.name
}

# Management VLAN interface (in-band management rides this)

resource "routeros_interface_vlan" "base_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "BASE_VLAN"
  vlan_id   = 99

  lifecycle {
    prevent_destroy = true
  }
}
