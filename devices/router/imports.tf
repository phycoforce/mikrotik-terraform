# ============================================================================
# Wave 1: system + certificates (services are adopt-on-apply, no import —
# routeros_ip_service is not importable in provider v1.99.1)
# ============================================================================

# Singletons import with the literal id "."
import {
  to = routeros_system_identity.identity
  id = "."
}

import {
  to = routeros_system_clock.clock
  id = "."
}

import {
  to = routeros_system_scheduler.scheduled_reboot
  id = "*1"
}

# Certificates by internal .id — re-issued 2026-07-30 with 3650-day validity
# (old *98/*9D rows were removed on-device; state was rm'd and re-imported)
import {
  to = routeros_system_certificate.local_root_cert
  id = "*9E"
}

import {
  to = routeros_system_certificate.webfig
  id = "*9F"
}

# ============================================================================
# Wave 2: L2 (ethernet, VLANs, interface lists, bridge) + IP addressing
# All ids below are RouterOS internal .id values read from router-ids.json
# (snapshot of 2026-07-30). Builtin interface lists (all/none/dynamic/static)
# and every dynamic:true row are excluded — nothing dynamic is managed.
# ============================================================================

# interfaces.tf — ethernet interfaces
# NOTE: after import the first apply records factory_name into state as an
# in-place update on each of these. That is expected and touches nothing
# on-device.
import {
  to = routeros_interface_ethernet.ether1
  id = "*1"
}

import {
  to = routeros_interface_ethernet.ether2
  id = "*2"
}

import {
  to = routeros_interface_ethernet.ether3
  id = "*3"
}

import {
  to = routeros_interface_ethernet.ether4
  id = "*4"
}

import {
  to = routeros_interface_ethernet.ether5
  id = "*5"
}

import {
  to = routeros_interface_ethernet.ether6
  id = "*6"
}

import {
  to = routeros_interface_ethernet.ether7
  id = "*7"
}

import {
  to = routeros_interface_ethernet.ether8
  id = "*8"
}

import {
  to = routeros_interface_ethernet.sfp_sfpplus1
  id = "*9"
}

# interfaces.tf — VLAN interfaces
import {
  to = routeros_interface_vlan.base_vlan
  id = "*B"
}

import {
  to = routeros_interface_vlan.trusted_vlan
  id = "*C"
}

import {
  to = routeros_interface_vlan.server_vlan
  id = "*D"
}

import {
  to = routeros_interface_vlan.untrusted_vlan
  id = "*E"
}

import {
  to = routeros_interface_vlan.iot_vlan
  id = "*F"
}

import {
  to = routeros_interface_vlan.vodafone_vlan
  id = "*10"
}

# interfaces.tf — interface lists
import {
  to = routeros_interface_list.wan
  id = "*2000010"
}

import {
  to = routeros_interface_list.vlan
  id = "*2000011"
}

import {
  to = routeros_interface_list.base
  id = "*2000012"
}

import {
  to = routeros_interface_list.plex_client
  id = "*2000013"
}

# interfaces.tf — interface list members
import {
  to = routeros_interface_list_member.wan_vodafone_pppoe
  id = "*1"
}

import {
  to = routeros_interface_list_member.vlan_trusted_vlan
  id = "*2"
}

import {
  to = routeros_interface_list_member.vlan_untrusted_vlan
  id = "*3"
}

import {
  to = routeros_interface_list_member.vlan_server_vlan
  id = "*4"
}

import {
  to = routeros_interface_list_member.vlan_base_vlan
  id = "*5"
}

import {
  to = routeros_interface_list_member.base_base_vlan
  id = "*6"
}

import {
  to = routeros_interface_list_member.vlan_iot_vlan
  id = "*7"
}

import {
  to = routeros_interface_list_member.plex_client_trusted_vlan
  id = "*8"
}

import {
  to = routeros_interface_list_member.plex_client_untrusted_vlan
  id = "*9"
}

# interfaces.tf — detect-internet singleton.
# Verified in the provider source (resource_interface_detect_internet.go,
# v1.99.1): the importer is schema.ImportStatePassthroughContext, so the
# literal "." id is correct here — unlike the switch's
# routeros_ip_neighbor_discovery_settings, which needs an asterisk id.
import {
  to = routeros_interface_detect_internet.detect_internet
  id = "."
}

# bridge.tf — bridge
import {
  to = routeros_interface_bridge.br1
  id = "*A"
}

# bridge.tf — bridge ports
import {
  to = routeros_interface_bridge_port.ether1
  id = "*0"
}

import {
  to = routeros_interface_bridge_port.ether3
  id = "*1"
}

import {
  to = routeros_interface_bridge_port.ether4
  id = "*2"
}

import {
  to = routeros_interface_bridge_port.ether5
  id = "*3"
}

import {
  to = routeros_interface_bridge_port.ether6
  id = "*4"
}

import {
  to = routeros_interface_bridge_port.ether7
  id = "*5"
}

import {
  to = routeros_interface_bridge_port.ether8
  id = "*6"
}

import {
  to = routeros_interface_bridge_port.sfp_sfpplus1
  id = "*7"
}

# bridge.tf — bridge VLANs (static rows only; the dynamic "added by pvid"
# rows *D/*14/*1C3/*23E/*24F are deliberately not imported)
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
  id = "*C"
}

import {
  to = routeros_interface_bridge_vlan.vlan99
  id = "*4"
}

# ip-addressing.tf — interface addresses
import {
  to = routeros_ip_address.base_vlan
  id = "*1"
}

import {
  to = routeros_ip_address.trusted_vlan
  id = "*3"
}

import {
  to = routeros_ip_address.server_vlan
  id = "*4"
}

import {
  to = routeros_ip_address.untrusted_vlan
  id = "*5"
}

import {
  to = routeros_ip_address.iot_vlan
  id = "*6"
}

# ============================================================================
# Wave 3: IP pools, DHCP (servers/networks/leases), DNS, firewall address lists
# All ids below are RouterOS internal .id values read from router-ids.json
# (snapshot of 2026-07-30), matched on identifying attributes rather than on
# row order. Every dynamic:true row is excluded — the 16 dynamic DHCP leases
# and the 56 ExternalDNS-owned static DNS records are NOT managed.
#
# Import mechanics verified in the provider source (v1.99.1): every resource in
# this wave uses MetaId PropId(Id) with ImportStateCustomContext, and that
# importer passes an id through untouched when it starts with "*". So the
# asterisk .id is the correct import id for all of them — none of them hit the
# PropId(Name)+ImportStateCustomContext bug that makes routeros_ip_service
# unimportable.
# ============================================================================

# dhcp.tf — IP pools
import {
  to = routeros_ip_pool.trusted_pool
  id = "*1"
}

import {
  to = routeros_ip_pool.server_pool
  id = "*2"
}

import {
  to = routeros_ip_pool.untrusted_pool
  id = "*3"
}

import {
  to = routeros_ip_pool.base_pool
  id = "*4"
}

import {
  to = routeros_ip_pool.iot_pool
  id = "*5"
}

# dhcp.tf — DHCP servers
import {
  to = routeros_ip_dhcp_server.trusted_dhcp
  id = "*1"
}

import {
  to = routeros_ip_dhcp_server.server_dhcp
  id = "*2"
}

import {
  to = routeros_ip_dhcp_server.untrusted_dhcp
  id = "*3"
}

import {
  to = routeros_ip_dhcp_server.base_dhcp
  id = "*4"
}

import {
  to = routeros_ip_dhcp_server.iot_dhcp
  id = "*5"
}

# dhcp.tf — DHCP networks
# NOTE: the ids are not in subnet order on-device — 10.0.40.0/24 is *5 and
# 192.168.0.0/24 is *4. Matched on the address attribute, not on position.
import {
  to = routeros_ip_dhcp_server_network.trusted
  id = "*1"
}

import {
  to = routeros_ip_dhcp_server_network.server
  id = "*2"
}

import {
  to = routeros_ip_dhcp_server_network.untrusted
  id = "*3"
}

import {
  to = routeros_ip_dhcp_server_network.iot
  id = "*5"
}

import {
  to = routeros_ip_dhcp_server_network.base
  id = "*4"
}

# dhcp.tf — static DHCP leases (11 of 27 rows; the 16 dynamic:true leases are
# deliberately not imported)
import {
  to = routeros_ip_dhcp_server_lease.trusted_85
  id = "*4B35"
}

import {
  to = routeros_ip_dhcp_server_lease.trusted_9
  id = "*577B"
}

import {
  to = routeros_ip_dhcp_server_lease.trusted_2
  id = "*5C53"
}

import {
  to = routeros_ip_dhcp_server_lease.server_aionios
  id = "*6238"
}

import {
  to = routeros_ip_dhcp_server_lease.server_logos
  id = "*BA09"
}

import {
  to = routeros_ip_dhcp_server_lease.server_ontos
  id = "*BA12"
}

import {
  to = routeros_ip_dhcp_server_lease.server_pneuma
  id = "*BA10"
}

import {
  to = routeros_ip_dhcp_server_lease.untrusted_aarons_kindle
  id = "*D78F"
}

import {
  to = routeros_ip_dhcp_server_lease.untrusted_alexs_kindle
  id = "*D942"
}

import {
  to = routeros_ip_dhcp_server_lease.iot_12
  id = "*5C45"
}

import {
  to = routeros_ip_dhcp_server_lease.iot_13
  id = "*5C80"
}

# dns.tf — routeros_ip_dns has NO Importer in provider v1.99.1: the DNS
# settings cannot be imported at any id. The resource is adopted on first
# apply, when the provider POSTs the configured attributes to /ip/dns/set.
# Every live non-default is reproduced in dns.tf, so that apply is a no-op
# on-device. Same pattern as routeros_ip_service. NO IMPORT BLOCK.

# dns.tf — static DNS records (7 of 63 rows; the 56 rows commented
# "Managed by ExternalDNS" are deliberately not imported — see §6.1)
import {
  to = routeros_ip_dns_record.aionios_internal
  id = "*365"
}

import {
  to = routeros_ip_dns_record.pihole_internal
  id = "*3EA"
}

import {
  to = routeros_ip_dns_record.nextdns_a1
  id = "*42D"
}

import {
  to = routeros_ip_dns_record.nextdns_a2
  id = "*42E"
}

import {
  to = routeros_ip_dns_record.nextdns_aaaa1
  id = "*42F"
}

import {
  to = routeros_ip_dns_record.nextdns_aaaa2
  id = "*430"
}

import {
  to = routeros_ip_dns_record.palworld_bunny_ac
  id = "*90C"
}

# firewall-addr-lists.tf — address list entries
import {
  to = routeros_ip_firewall_addr_list.k8s_logos
  id = "*1"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_ontos
  id = "*2"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_pneuma
  id = "*3"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_postgres
  id = "*4"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_internal_ingress
  id = "*5"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_external_ingress
  id = "*6"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_plex
  id = "*7"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_kube_vip
  id = "*8"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_aionios
  id = "*9"
}

import {
  to = routeros_ip_firewall_addr_list.k8s_owncast_ingress
  id = "*A"
}

import {
  to = routeros_ip_firewall_addr_list.kindles_aaron
  id = "*B"
}

import {
  to = routeros_ip_firewall_addr_list.kindles_alex
  id = "*C"
}

# ============================================================================
# Wave 4: firewall filter + NAT + rule ordering
#
# All ids below are RouterOS internal .id values read from router-ids.json
# (snapshot of 2026-07-30 12:43). Rows were matched to rules on
# chain + comment + distinguishing matchers, NOT on array position — the two
# chain=forward rows that share the comment "Allow Estab & Related" are told
# apart by action (fasttrack-connection *5C vs accept *57), and the two that
# share "Trusted VLAN to Cilium" by action + connection-state
# (fasttrack/established,related *69 vs accept/new *64).
#
# ORDER CHECK: the REST read returns rules in table order, and after excluding
# the one dynamic row the /ip/firewall/filter array order is exactly
#   *53 *54 *55 *70 *56 *5C *57 *69 *64 *7A *76 *79 *72 *58 *73 *7B *74
# and /ip/firewall/nat is exactly
#   *1 *6 *7 *5
# Both match the export order rule-for-rule. No discrepancy, so the `sequence`
# lists in firewall.tf / nat.tf describe the order the device is already in and
# the move on first apply is a no-op.
#
# EXCLUDED: /ip/firewall/filter row *77 — action=passthrough, chain=forward,
# comment "special dummy rule to show fasttrack counters", dynamic=true. It is
# generated by RouterOS to carry the fasttrack counters, it is the first row of
# the REST array, and it is neither imported nor named in the move sequence.
# It is the only dynamic row in either menu.
#
# Import mechanics: routeros_ip_firewall_filter and routeros_ip_firewall_nat
# both use MetaId PropId(Id) with ImportStateCustomContext, which passes an id
# starting with "*" through untouched — so the asterisk .id is the correct
# import id for all 21 rules.
#
# NOT IMPORTABLE: routeros_move_items has no Importer in provider v1.99.1
# (verified in routeros/resource_move.go). The two move_items resources
# therefore have NO import block and are created on the first apply. Their
# create issues one RouterOS move per menu; because the device is already in
# the configured order, both moves are functional no-ops.
# ============================================================================

# firewall.tf — filter rules, chain=input (rules 1-5, in chain order)
import {
  to = routeros_ip_firewall_filter.input_accept_estab
  id = "*53"
}

import {
  to = routeros_ip_firewall_filter.input_accept_vlan
  id = "*54"
}

import {
  to = routeros_ip_firewall_filter.input_accept_base_vlan
  id = "*55"
}

# The .id ordering is not the chain ordering in this menu: "defconf: accept
# ICMP" is *70 and sits between *55 and *56. Matched on comment + protocol.
import {
  to = routeros_ip_firewall_filter.input_accept_icmp
  id = "*70"
}

import {
  to = routeros_ip_firewall_filter.input_drop_all
  id = "*56"
}

# firewall.tf — filter rules, chain=forward (rules 6-17, in chain order)
import {
  to = routeros_ip_firewall_filter.forward_fasttrack_estab
  id = "*5C"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_estab
  id = "*57"
}

import {
  to = routeros_ip_firewall_filter.forward_fasttrack_cilium
  id = "*69"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_cilium
  id = "*64"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_kindles_cilium
  id = "*7A"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_squid
  id = "*76"
}

# The row carrying the empty-string src-address-list — see the note on this
# resource in firewall.tf.
import {
  to = routeros_ip_firewall_filter.forward_accept_owncast
  id = "*79"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_plex
  id = "*72"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_vlan_internet
  id = "*58"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_soulseek
  id = "*73"
}

import {
  to = routeros_ip_firewall_filter.forward_accept_palworld
  id = "*7B"
}

# The terminal forward drop. It is DISABLED on the live device (the REST row
# reads "disabled": "true"), and firewall.tf pins disabled = true to match, so
# this import is a clean no-op. See the long note on the resource.
import {
  to = routeros_ip_firewall_filter.forward_drop_all
  id = "*74"
}

# nat.tf — NAT rules (in chain order)
import {
  to = routeros_ip_firewall_nat.srcnat_masquerade
  id = "*1"
}

import {
  to = routeros_ip_firewall_nat.dstnat_soulseek
  id = "*6"
}

import {
  to = routeros_ip_firewall_nat.dstnat_palworld
  id = "*7"
}


# ============================================================================
# Wave 5: PPPoE client (import by internal .id; password matches live value,
# verified via REST with the sensitive policy — adoption writes nothing)
# ============================================================================
import {
  to = routeros_interface_pppoe_client.vodafone
  id = "*11"
}

# ============================================================================
# Wave 6: misc singletons. Passthrough importers take "." (connection
# tracking, ipv6 settings, sniffer); ImportStateCustomContext resources
# (ipsec profile, ipv6 nd) import by internal .id.
# ============================================================================
import {
  to = routeros_ip_firewall_connection_tracking.settings
  id = "."
}

import {
  to = routeros_ip_neighbor_discovery_settings.settings
  id = "*1"
}

import {
  to = routeros_ip_ipsec_profile.default
  id = "*A"
}

import {
  to = routeros_ipv6_settings.settings
  id = "."
}

import {
  to = routeros_ipv6_neighbor_discovery.default
  id = "*1"
}

import {
  to = routeros_tool_sniffer.settings
  id = "."
}

# ============================================================================
# Wave 7: BGP — the Cilium peerings (highest blast radius; see routing-bgp.tf).
#
# All three resources are MetaId: PropId(Id) with ImportStateCustomContext
# (resource_routing_bgp_instance.go:21,74; resource_routing_bgp_template.go:58
# + Importer; resource_routing_bgp_connection.go:71,598). That combination is
# the SAFE one: ImportStateCustomContext short-circuits on any id starting with
# "*" (resource_actions.go:370-371) and the subsequent read is by .id, so the
# asterisk form below is an unambiguous passthrough. (Import-by-name would also
# resolve here, since the custom context looks the name up and swaps in the
# .id — that only breaks when MetaId is PropId(Name).)
#
# The `default` BGP template is imported, never created — RouterOS ships it.
# ============================================================================
import {
  to = routeros_routing_bgp_instance.bgp_instance_1
  id = "*1"
}

import {
  to = routeros_routing_bgp_template.default
  id = "*1"
}

import {
  to = routeros_routing_bgp_connection.logos
  id = "*11"
}

import {
  to = routeros_routing_bgp_connection.pneuma
  id = "*12"
}

import {
  to = routeros_routing_bgp_connection.ontos
  id = "*13"
}

# ============================================================================
# Post-migration additions (2026-07-30 report decisions)
# ============================================================================
import {
  to = routeros_system_ntp_client.ntp_client
  id = "."
}

import {
  to = routeros_system_user.external_dns
  id = "*3"
}
