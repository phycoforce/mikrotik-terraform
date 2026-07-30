resource "routeros_system_identity" "identity" {
  name = "Router"
}
resource "routeros_system_clock" "set" {
  time_zone_name = "Europe/London"
}

resource "routeros_ipv6_settings" "settings" {
  disable_ipv6 = true
}

resource "routeros_ip_neighbor_discovery_settings" "set" {
  discover_interface_list = "all"
}
resource "routeros_ip_firewall_connection_tracking" "set" {
  enabled     = "yes"
  udp_timeout = "10s"
}