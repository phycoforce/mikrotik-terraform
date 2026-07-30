# Interface IP addresses
# One gateway address per VLAN interface. The dynamic PPPoE WAN address
# (84.64.167.76/32 on Vodafone_PPPOE) is assigned by the ISP and is not managed.

# Management address (in-band, rides BASE_VLAN)
resource "routeros_ip_address" "base_vlan" {
  address   = "192.168.0.1/24"
  interface = routeros_interface_vlan.base_vlan.name
  network   = "192.168.0.0"

  lifecycle {
    prevent_destroy = true
  }
}

resource "routeros_ip_address" "trusted_vlan" {
  address   = "10.0.10.1/24"
  interface = routeros_interface_vlan.trusted_vlan.name
  network   = "10.0.10.0"
}

resource "routeros_ip_address" "server_vlan" {
  address   = "10.0.20.1/24"
  interface = routeros_interface_vlan.server_vlan.name
  network   = "10.0.20.0"
}

resource "routeros_ip_address" "untrusted_vlan" {
  address   = "10.0.30.1/24"
  interface = routeros_interface_vlan.untrusted_vlan.name
  network   = "10.0.30.0"
}

resource "routeros_ip_address" "iot_vlan" {
  address   = "10.0.40.1/24"
  interface = routeros_interface_vlan.iot_vlan.name
  network   = "10.0.40.0"
}
