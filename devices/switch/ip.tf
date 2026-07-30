# Management IP (in-band, rides BASE_VLAN)

resource "routeros_ip_address" "mgmt" {
  address   = "192.168.0.2/24"
  interface = routeros_interface_vlan.base_vlan.name
  network   = "192.168.0.0"

  lifecycle {
    prevent_destroy = true
  }
}

# Default route

resource "routeros_ip_route" "default" {
  dst_address = "0.0.0.0/0"
  gateway     = "192.168.0.1"
  distance    = 1
}

# DNS client
# NOTE: routeros_ip_dns cannot be imported; on first apply the provider
# overwrites the device settings with this configuration. Both attributes
# below already match the live device, so that first apply changes nothing
# on-device. Every other /ip dns attribute is at its RouterOS default and
# is deliberately left unset.

# allow_remote_requests turned off 2026-07-30 (report finding 4): nothing
# legitimately queries the switch for DNS — DHCP hands out 192.168.0.1 — and
# with it on, the switch was an open resolver to any VLAN that could route to
# it. The switch's own lookups are unaffected.
resource "routeros_ip_dns" "dns" {
  allow_remote_requests = false
  servers               = ["192.168.0.1"]

  # The provider's delete handler resets allow-remote-requests/servers —
  # removing this resource breaks switch DNS. Guard it.
  lifecycle { prevent_destroy = true }
}

# Neighbor discovery

resource "routeros_ip_neighbor_discovery_settings" "settings" {
  discover_interface_list = routeros_interface_list.base.name
}
