# IP pools
# One pool per VLAN. Every pool is a single contiguous range; the provider
# models ranges as a list. next_pool and comment are unset on every pool.

resource "routeros_ip_pool" "trusted_pool" {
  name   = "TRUSTED_POOL"
  ranges = ["10.0.10.2-10.0.10.200"]
}

resource "routeros_ip_pool" "server_pool" {
  name   = "SERVER_POOL"
  ranges = ["10.0.20.10-10.0.20.200"]
}

resource "routeros_ip_pool" "untrusted_pool" {
  name   = "UNTRUSTED_POOL"
  ranges = ["10.0.30.2-10.0.30.254"]
}

resource "routeros_ip_pool" "base_pool" {
  name   = "BASE_POOL"
  ranges = ["192.168.0.11-192.168.0.240"]
}

resource "routeros_ip_pool" "iot_pool" {
  name   = "IOT_POOL"
  ranges = ["10.0.40.2-10.0.40.240"]
}

# DHCP servers
# One server per VLAN interface, each bound to that VLAN's pool.
#
# lease_time (30m), authoritative, use_radius (no) and address_lists (empty)
# are all at their RouterOS defaults and carry the provider's
# AlwaysPresentNotUserProvided diff suppression, so they stay unset.
#
# EXCEPTION: dynamic_lease_identifiers IS set even though "client-mac,client-id"
# is the RouterOS default. The provider's schema for this attribute has no
# DiffSuppressFunc, so the value the import reads back into state would plan as
# a change to "" against an empty config and reset it on-device.

resource "routeros_ip_dhcp_server" "trusted_dhcp" {
  name                      = "TRUSTED_DHCP"
  address_pool              = routeros_ip_pool.trusted_pool.name
  interface                 = routeros_interface_vlan.trusted_vlan.name
  dynamic_lease_identifiers = "client-mac,client-id"
}

resource "routeros_ip_dhcp_server" "server_dhcp" {
  name                      = "SERVER_DHCP"
  address_pool              = routeros_ip_pool.server_pool.name
  interface                 = routeros_interface_vlan.server_vlan.name
  dynamic_lease_identifiers = "client-mac,client-id"
}

resource "routeros_ip_dhcp_server" "untrusted_dhcp" {
  name                      = "UNTRUSTED_DHCP"
  address_pool              = routeros_ip_pool.untrusted_pool.name
  interface                 = routeros_interface_vlan.untrusted_vlan.name
  dynamic_lease_identifiers = "client-mac,client-id"
}

resource "routeros_ip_dhcp_server" "base_dhcp" {
  name                      = "BASE_DHCP"
  address_pool              = routeros_ip_pool.base_pool.name
  interface                 = routeros_interface_vlan.base_vlan.name
  dynamic_lease_identifiers = "client-mac,client-id"
}

resource "routeros_ip_dhcp_server" "iot_dhcp" {
  name                      = "IOT_DHCP"
  address_pool              = routeros_ip_pool.iot_pool.name
  interface                 = routeros_interface_vlan.iot_vlan.name
  dynamic_lease_identifiers = "client-mac,client-id"
}

# DHCP networks
# Standalone rows keyed on the subnet, not on a DHCP server. TRUSTED and SERVER
# also hand out PXE/netboot.xyz pointers (next_server is aionios, 10.0.20.10).
#
# NOTE: IOT deliberately hands out public resolvers (1.1.1.1, 8.8.8.8) instead
# of the router — IoT clients do not use the router's DoH resolver.

resource "routeros_ip_dhcp_server_network" "trusted" {
  address        = "10.0.10.0/24"
  gateway        = "10.0.10.1"
  dns_server     = ["10.0.10.1"]
  boot_file_name = "netboot.xyz.efi"
  next_server    = "10.0.20.10"
}

resource "routeros_ip_dhcp_server_network" "server" {
  address        = "10.0.20.0/24"
  gateway        = "10.0.20.1"
  dns_server     = ["10.0.20.1"]
  boot_file_name = "netboot.xyz.efi"
  next_server    = "10.0.20.10"
}

resource "routeros_ip_dhcp_server_network" "untrusted" {
  address    = "10.0.30.0/24"
  gateway    = "10.0.30.1"
  dns_server = ["10.0.30.1"]
}

resource "routeros_ip_dhcp_server_network" "iot" {
  address    = "10.0.40.0/24"
  gateway    = "10.0.40.1"
  dns_server = ["1.1.1.1", "8.8.8.8"]
}

resource "routeros_ip_dhcp_server_network" "base" {
  address    = "192.168.0.0/24"
  gateway    = "192.168.0.1"
  dns_server = ["192.168.0.1"]
}

# Static DHCP leases
# Only the 11 static leases are managed; the 16 dynamic:true leases on the live
# device are not (and must not be) under Terraform management.
#
# host_name, class_id and every active_* attribute are read-only and are
# therefore not expressed here.

# TRUSTED_DHCP

# No comment on-device. Same MAC as the 10.0.40.12 IOT lease below, so this is
# one dual-homed device pinned on both VLANs.
resource "routeros_ip_dhcp_server_lease" "trusted_85" {
  address     = "10.0.10.85"
  mac_address = "80:8A:F7:0B:D7:C2"
  client_id   = "1:80:8a:f7:b:d7:c2"
  server      = routeros_ip_dhcp_server.trusted_dhcp.name
}

# No comment on-device.
resource "routeros_ip_dhcp_server_lease" "trusted_9" {
  address     = "10.0.10.9"
  mac_address = "48:B0:2D:54:0B:E4"
  client_id   = "1:48:b0:2d:54:b:e4"
  server      = routeros_ip_dhcp_server.trusted_dhcp.name
}

# No comment on-device.
resource "routeros_ip_dhcp_server_lease" "trusted_2" {
  address     = "10.0.10.2"
  mac_address = "00:04:4B:CE:5C:F0"
  client_id   = "1:0:4:4b:ce:5c:f0"
  server      = routeros_ip_dhcp_server.trusted_dhcp.name
}

# SERVER_DHCP — the Kubernetes nodes (PXE-booted via the netboot.xyz pointers
# on the 10.0.20.0/24 network above)

resource "routeros_ip_dhcp_server_lease" "server_aionios" {
  address     = "10.0.20.10"
  mac_address = "F8:F2:1E:79:D5:F0"
  client_id   = "1:f8:f2:1e:79:d5:f0"
  server      = routeros_ip_dhcp_server.server_dhcp.name
  comment     = "aionios"
}

resource "routeros_ip_dhcp_server_lease" "server_logos" {
  address     = "10.0.20.2"
  mac_address = "58:47:CA:7F:09:75"
  client_id   = "1:58:47:ca:7f:9:75"
  server      = routeros_ip_dhcp_server.server_dhcp.name
  comment     = "logos"
}

resource "routeros_ip_dhcp_server_lease" "server_ontos" {
  address     = "10.0.20.3"
  mac_address = "58:47:CA:7F:03:3D"
  client_id   = "1:58:47:ca:7f:3:3d"
  server      = routeros_ip_dhcp_server.server_dhcp.name
  comment     = "ontos"
}

resource "routeros_ip_dhcp_server_lease" "server_pneuma" {
  address     = "10.0.20.4"
  mac_address = "58:47:CA:7F:09:71"
  client_id   = "1:58:47:ca:7f:9:71"
  server      = routeros_ip_dhcp_server.server_dhcp.name
  comment     = "pneuma"
}

# UNTRUSTED_DHCP

resource "routeros_ip_dhcp_server_lease" "untrusted_aarons_kindle" {
  address     = "10.0.30.15"
  mac_address = "78:A0:3F:C0:80:7A"
  client_id   = "1:78:a0:3f:c0:80:7a"
  server      = routeros_ip_dhcp_server.untrusted_dhcp.name
  comment     = "Aaron's Kindle"
}

resource "routeros_ip_dhcp_server_lease" "untrusted_alexs_kindle" {
  address     = "10.0.30.18"
  mac_address = "20:BE:B8:B0:77:6C"
  client_id   = "1:20:be:b8:b0:77:6c"
  server      = routeros_ip_dhcp_server.untrusted_dhcp.name
  comment     = "Alex's Kindle"
}

# IOT_DHCP

# No comment on-device. Same MAC as the 10.0.10.85 TRUSTED lease above.
resource "routeros_ip_dhcp_server_lease" "iot_12" {
  address     = "10.0.40.12"
  mac_address = "80:8A:F7:0B:D7:C2"
  client_id   = "1:80:8a:f7:b:d7:c2"
  server      = routeros_ip_dhcp_server.iot_dhcp.name
}

# No comment on-device; host-name reads Roomba-80B5042052516800. This is the one
# static lease with no client-id — it is matched on MAC only.
resource "routeros_ip_dhcp_server_lease" "iot_13" {
  address     = "10.0.40.13"
  mac_address = "20:4E:F6:B0:47:33"
  server      = routeros_ip_dhcp_server.iot_dhcp.name
}
