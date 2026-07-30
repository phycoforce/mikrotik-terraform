# Ethernet interfaces
# Physical ports exist in hardware; they are imported and only updated.
# Non-defaults: l2mtu only. Every port is at 9084 (jumbo frames) except
# ether2 (the WAN handoff to the Vodafone ONT) which sits at 1514.
# NOTE: L3 mtu is left at the 1500 default everywhere, exactly as live.
# routeros_interface_ethernet requires both factory_name and name; name is
# set to the factory default because no port has been renamed on this device.

resource "routeros_interface_ethernet" "ether1" {
  factory_name = "ether1"
  name         = "ether1"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether2" {
  factory_name = "ether2"
  name         = "ether2"
  l2mtu        = 1514
}

resource "routeros_interface_ethernet" "ether3" {
  factory_name = "ether3"
  name         = "ether3"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether4" {
  factory_name = "ether4"
  name         = "ether4"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether5" {
  factory_name = "ether5"
  name         = "ether5"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether6" {
  factory_name = "ether6"
  name         = "ether6"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether7" {
  factory_name = "ether7"
  name         = "ether7"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "ether8" {
  factory_name = "ether8"
  name         = "ether8"
  l2mtu        = 9084
}

resource "routeros_interface_ethernet" "sfp_sfpplus1" {
  factory_name = "sfp-sfpplus1"
  name         = "sfp-sfpplus1"
  l2mtu        = 9084
}

# VLAN interfaces
# All ride BR1 except VODAFONE_VLAN, which is the tagged WAN VLAN on ether2.

# Management VLAN interface (in-band management rides this)
resource "routeros_interface_vlan" "base_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "BASE_VLAN"
  vlan_id   = 99

  lifecycle {
    prevent_destroy = true
  }
}

resource "routeros_interface_vlan" "trusted_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "TRUSTED_VLAN"
  vlan_id   = 10
}

resource "routeros_interface_vlan" "server_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "SERVER_VLAN"
  vlan_id   = 20
}

resource "routeros_interface_vlan" "untrusted_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "UNTRUSTED_VLAN"
  vlan_id   = 30
}

resource "routeros_interface_vlan" "iot_vlan" {
  interface = routeros_interface_bridge.br1.name
  name      = "IOT_VLAN"
  vlan_id   = 40
}

resource "routeros_interface_vlan" "vodafone_vlan" {
  interface = routeros_interface_ethernet.ether2.name
  name      = "VODAFONE_VLAN"
  vlan_id   = 911
}

# Interface lists
# Builtin lists (all/none/dynamic/static) are deliberately not managed.

resource "routeros_interface_list" "wan" {
  name = "WAN"
}

resource "routeros_interface_list" "vlan" {
  name = "VLAN"
}

resource "routeros_interface_list" "base" {
  name = "BASE"
}

# MGMT — added 2026-07-30 (report finding 3): the VLANs allowed full access
# to router management. Referenced by the "Allow Management VLANs to Router"
# input rule in firewall.tf.
resource "routeros_interface_list" "mgmt" {
  name    = "MGMT"
  comment = "VLANs with full router management access"
}

resource "routeros_interface_list_member" "mgmt_base_vlan" {
  interface = routeros_interface_vlan.base_vlan.name
  list      = routeros_interface_list.mgmt.name
}

resource "routeros_interface_list_member" "mgmt_trusted_vlan" {
  interface = routeros_interface_vlan.trusted_vlan.name
  list      = routeros_interface_list.mgmt.name
}

resource "routeros_interface_list" "plex_client" {
  name    = "PLEX_CLIENT"
  comment = "Plex Client VLAN Interface Members"
}

# Interface list members

# EXCEPTION: "Vodafone_PPPOE" is a literal string, not a resource reference.
# The routeros_interface_pppoe_client resource is a later migration wave, so
# there is nothing to reference yet. Convert this to a reference once the
# PPPoE client is under management.
resource "routeros_interface_list_member" "wan_vodafone_pppoe" {
  interface = "Vodafone_PPPOE"
  list      = routeros_interface_list.wan.name
}

resource "routeros_interface_list_member" "vlan_trusted_vlan" {
  interface = routeros_interface_vlan.trusted_vlan.name
  list      = routeros_interface_list.vlan.name
}

resource "routeros_interface_list_member" "vlan_untrusted_vlan" {
  interface = routeros_interface_vlan.untrusted_vlan.name
  list      = routeros_interface_list.vlan.name
}

resource "routeros_interface_list_member" "vlan_server_vlan" {
  interface = routeros_interface_vlan.server_vlan.name
  list      = routeros_interface_list.vlan.name
}

resource "routeros_interface_list_member" "vlan_base_vlan" {
  interface = routeros_interface_vlan.base_vlan.name
  list      = routeros_interface_list.vlan.name
}

resource "routeros_interface_list_member" "base_base_vlan" {
  interface = routeros_interface_vlan.base_vlan.name
  list      = routeros_interface_list.base.name
}

resource "routeros_interface_list_member" "vlan_iot_vlan" {
  interface = routeros_interface_vlan.iot_vlan.name
  list      = routeros_interface_list.vlan.name
}

resource "routeros_interface_list_member" "plex_client_trusted_vlan" {
  interface = routeros_interface_vlan.trusted_vlan.name
  list      = routeros_interface_list.plex_client.name
}

resource "routeros_interface_list_member" "plex_client_untrusted_vlan" {
  interface = routeros_interface_vlan.untrusted_vlan.name
  list      = routeros_interface_list.plex_client.name
}

# Detect Internet (singleton)
# Only wan-interface-list is set on the live device; the other three lists
# (detect/internet/lan) are at their "none" defaults and stay unmanaged.

resource "routeros_interface_detect_internet" "detect_internet" {
  wan_interface_list = routeros_interface_list.wan.name
}
