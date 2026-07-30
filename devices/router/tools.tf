# MAC server (MAC Telnet / MAC WinBox access)
#
# Restricted to the MGMT list on 2026-07-30 (post-migration audit): the live
# device carried the factory default allowed-interface-list=all, which answers
# MAC-Telnet/MAC-WinBox on every bridge port and VLAN. MAC-server access is
# layer-2 and bypasses the /ip firewall input chain entirely, so "all" quietly
# undid the input-chain lockdown and the neighbor-discovery restriction.
# Mirrors the switch module, which pins the same two settings to its BASE list.
# IP-based recovery over ether1/VLAN 99 is unaffected.

resource "routeros_tool_mac_server" "settings" {
  allowed_interface_list = routeros_interface_list.mgmt.name

  depends_on = [
    routeros_interface_list_member.mgmt_base_vlan,
    routeros_interface_list_member.mgmt_trusted_vlan,
  ]
}

resource "routeros_tool_mac_server_winbox" "settings" {
  allowed_interface_list = routeros_interface_list.mgmt.name

  depends_on = [
    routeros_interface_list_member.mgmt_base_vlan,
    routeros_interface_list_member.mgmt_trusted_vlan,
  ]
}

# Bandwidth-test responder ("btest", TCP/UDP 2000) — RouterOS ships it
# enabled. Unused on this network, so disabled 2026-07-30 (post-migration
# audit follow-up); authenticate/max-sessions stay at their defaults.
resource "routeros_tool_bandwidth_server" "settings" {
  enabled = false
}
