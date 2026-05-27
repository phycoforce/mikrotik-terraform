resource "routeros_interface_bridge" "bridge" {
  name           = var.bridge_name
  comment        = var.bridge_comment
  mtu            = var.bridge_mtu == null ? null : tostring(var.bridge_mtu)
  vlan_filtering = var.bridge_vlan_filtering
}

resource "routeros_interface_bridge_port" "bridge_ports" {
  for_each = {
    "ether1"       = { comment = "", pvid = "99" }
    "ether3"       = { comment = "", pvid = "10" }
    "ether4"       = { comment = "", pvid = "20" }
    "ether5"       = { comment = "", pvid = "20" }
    "ether6"       = { comment = "", pvid = "20" }
    "ether7"       = { comment = "", pvid = "40" }
    "ether8"       = { comment = "", pvid = "20" }
    "sfp-sfpplus1" = { comment = "", pvid = "99" }
  }
  bridge    = routeros_interface_bridge.bridge.name
  interface = each.key
  comment   = each.value.comment
  pvid      = each.value.pvid
}