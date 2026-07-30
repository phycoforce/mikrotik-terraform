# Miscellaneous singletons and default-row resources (MIGRATION-BRIEF §5 —
# every one of these is a "set" resource that overwrites rather than merges;
# only live non-defaults are set, verified against REST on 2026-07-30).

# Connection tracking: enabled=yes + the deliberate 10s UDP timeout tune.
# tcp-established-timeout 1d / generic-timeout 10m are defaults, left unset.
resource "routeros_ip_firewall_connection_tracking" "settings" {
  enabled     = "yes"
  udp_timeout = "10s"
}

# Neighbor discovery on ALL interfaces — flagged in the §7.3 security notes
# (discovery is visible from IOT/UNTRUSTED VLANs); imported as-is.
resource "routeros_ip_neighbor_discovery_settings" "settings" {
  discover_interface_list = "all"
}

# IPsec default profile (default=yes row): only the DPD tune is non-default.
resource "routeros_ip_ipsec_profile" "default" {
  name                 = "default"
  dpd_interval         = "2m"
  dpd_maximum_failures = 5
}

# IPv6 is disabled network-wide — §5: re-enabling would bypass the entire
# IPv4-only firewall policy.
resource "routeros_ipv6_settings" "settings" {
  disable_ipv6 = true
}

# IPv6 ND default row: advertise-dns=yes (inert while IPv6 is disabled).
resource "routeros_ipv6_neighbor_discovery" "default" {
  interface     = "all"
  advertise_dns = true
}

# Packet sniffer (TZSP streaming to 10.0.20.12). enabled=false pinned — the
# provider defaults it to true when unset, which would start a capture.
resource "routeros_tool_sniffer" "settings" {
  enabled           = false
  filter_interface  = [routeros_interface_ethernet.sfp_sfpplus1.name]
  filter_vlan       = [40]
  streaming_enabled = true
  streaming_server  = "10.0.20.12:37008"
}
