# MAC server (MAC Telnet / MAC WinBox access)

resource "routeros_tool_mac_server" "settings" {
  allowed_interface_list = routeros_interface_list.base.name
}

resource "routeros_tool_mac_server_winbox" "settings" {
  allowed_interface_list = routeros_interface_list.base.name
}

# Packet sniffer (TZSP streaming to capture host)
# streaming_server carries the default TZSP port :37008 explicitly because
# RouterOS appends it and reports "10.0.20.12:37008" via the API; the bare
# IP from the CLI export would produce a permanent plan diff.

resource "routeros_tool_sniffer" "settings" {
  # enabled=false: the sniffer is configured but not running; the provider
  # defaults enabled to true when unset, which would start a capture.
  enabled           = false
  filter_interface  = [routeros_interface_bridge.br1.name]
  filter_vlan       = [40]
  streaming_enabled = true
  streaming_server  = "10.0.20.12:37008"
}
