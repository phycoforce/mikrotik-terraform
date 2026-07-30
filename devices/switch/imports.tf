# system.tf — singletons import with the literal id "." per provider docs
import {
  to = routeros_system_identity.identity
  id = "."
}

import {
  to = routeros_system_clock.clock
  id = "."
}

import {
  to = routeros_system_ntp_client.ntp_client
  id = "."
}

import {
  to = routeros_system_routerboard_settings.routerboard
  id = "."
}

import {
  to = routeros_system_scheduler.scheduled_reboot
  id = "*0"
}

# certificates.tf — import by RouterOS internal .id
import {
  to = routeros_system_certificate.local_root_cert
  id = "*1"
}

import {
  to = routeros_system_certificate.webfig
  id = "*3"
}

# services.tf — routeros_ip_service is NOT importable in provider v1.99.1:
# both documented id forms end in a read that filters name=<internal-id> and
# finds nothing (provider bug). The resource's create is a RouterOS
# "set numbers=<name>" on the existing row, so the services are adopted on
# first apply with values identical to live state — same pattern as
# routeros_ip_dns. No import blocks.


# L2: ethernet interfaces
import {
  to = routeros_interface_ethernet.ether1
  id = "*A"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus1
  id = "*2"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus2
  id = "*3"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus3
  id = "*4"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus4
  id = "*5"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus5
  id = "*6"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus6
  id = "*7"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus7
  id = "*8"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus8
  id = "*9"
}

# L2: interface list, list member, management VLAN interface
import {
  to = routeros_interface_list.base
  id = "*2000010"
}

import {
  to = routeros_interface_list_member.base_vlan
  id = "*1"
}

import {
  to = routeros_interface_vlan.base_vlan
  id = "*F"
}

# L2: bridge
import {
  to = routeros_interface_bridge.br1
  id = "*C"
}

# L2: bridge ports
import {
  to = routeros_interface_bridge_port.ether1
  id = "*0"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus2
  id = "*14"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus4
  id = "*D"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus5
  id = "*E"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus6
  id = "*10"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus7
  id = "*11"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus8
  id = "*12"
}

# L2: bridge VLANs (static rows only)
import {
  to = routeros_interface_bridge_vlan.vlan10
  id = "*1"
}

import {
  to = routeros_interface_bridge_vlan.vlan20
  id = "*2"
}

import {
  to = routeros_interface_bridge_vlan.vlan30
  id = "*3"
}

import {
  to = routeros_interface_bridge_vlan.vlan40
  id = "*4"
}

import {
  to = routeros_interface_bridge_vlan.vlan99
  id = "*5"
}


import {
  to = routeros_ip_address.mgmt
  id = "*2"
}

import {
  to = routeros_ip_route.default
  id = "*80000001"
}

# The documented "." import id is broken for this resource in v1.99.1 (its
# importer does a name=. lookup against a settings endpoint that has no .id).
# Any asterisk-prefixed id takes the passthrough path instead; the follow-up
# read ignores the id and reads the settings endpoint directly.
import {
  to = routeros_ip_neighbor_discovery_settings.settings
  id = "*1"
}

import {
  to = routeros_tool_mac_server.settings
  id = "."
}

import {
  to = routeros_tool_mac_server_winbox.settings
  id = "."
}

import {
  to = routeros_tool_sniffer.settings
  id = "."
}

# ============================================================================
# Post-migration: user management (2026-07-30)
# ============================================================================
import {
  to = routeros_system_user_group.terraform
  id = "*4"
}

import {
  to = routeros_system_user.terraform
  id = "*3"
}

import {
  to = routeros_system_user.aaron
  id = "*2"
}

# ============================================================================
# Post-migration audit adoptions (2026-07-30). ipv6 settings is a passthrough
# singleton ("."); the ipv6 nd default row and the admin user import by
# internal .id.
# ============================================================================
import {
  to = routeros_system_user.admin
  id = "*1"
}

import {
  to = routeros_ipv6_settings.settings
  id = "."
}

import {
  to = routeros_ipv6_neighbor_discovery.default
  id = "*1"
}
