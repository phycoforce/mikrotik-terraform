# DNS settings (singleton)
#
# ⚠️ HIGHEST-RISK RESOURCE IN THIS WAVE (MIGRATION-BRIEF.md §5).
# routeros_ip_dns CANNOT be imported: the resource has no Importer at all in
# provider v1.99.1. Its create is a POST to /ip/dns/set, so this block is
# adopted on first apply and OVERWRITES the live DNS settings wholesale rather
# than merging. Every non-default on the live device is therefore reproduced
# below verbatim, and every attribute sitting at its RouterOS default is
# deliberately omitted (the provider skips empty Optional fields, so omitted
# attributes are not sent in the POST and stay untouched).
#
# Live non-defaults reproduced here (verified against router-ids.json,
# 2026-07-30):
#   allow-remote-requests = true      (default no)
#   cache-max-ttl         = 1d        (default 1w)
#   mdns-repeat-ifaces    = IOT_VLAN,TRUSTED_VLAN   (default empty)
#   use-doh-server        = https://dns.nextdns.io/251f43   (default empty)
#   verify-doh-cert       = true      (default no)
#
# Live attributes left unset because they are at their defaults:
#   address-list-extra-time 0s | cache-size 2048 | doh-max-concurrent-queries 50
#   doh-max-server-connections 5 | doh-timeout 5s | max-concurrent-queries 100
#   max-concurrent-tcp-sessions 20 | max-udp-packet-size 4096
#   query-server-timeout 2s | query-total-timeout 10s | vrf main
#
# servers is EMPTY on the live device and is left unset: DoH (NextDNS) is the
# resolver. dynamic-servers (90.255.255.90,90.255.255.255, learned from the
# Vodafone PPPoE link) and cache-used are read-only and cannot be expressed.
#
# 🔴 Setting servers here, or dropping use_doh_server, changes DNS resolution
# behaviour for the entire network.

resource "routeros_ip_dns" "dns" {
  allow_remote_requests = true
  cache_max_ttl         = "1d"
  use_doh_server        = "https://dns.nextdns.io/251f43"
  verify_doh_cert       = true

  mdns_repeat_ifaces = [
    routeros_interface_vlan.iot_vlan.name,
    routeros_interface_vlan.trusted_vlan.name,
  ]

  # The provider's delete handler resets allow-remote-requests/servers/
  # use-doh-server/verify-doh-cert — removing this resource kills DNS
  # network-wide. Guard it.
  lifecycle { prevent_destroy = true }
}

# Static DNS records
#
# 🚫 ONLY 7 of the 63 live /ip dns static entries are managed here
# (MIGRATION-BRIEF.md §6.1). The other 56 carry comment="Managed by ExternalDNS"
# and are owned by ExternalDNS in the Kubernetes cluster. Putting those under
# Terraform creates a permanent reconciliation fight: ExternalDNS re-adds what
# Terraform deletes and Terraform deletes what ExternalDNS adds, forever.
# DO NOT ADD THEM HERE.
#
# All 7 rows below are ttl=1d on-device, which is the RouterOS default, so ttl
# is left unset (the provider's TimeEqual diff suppression covers it).
#
# dns.nextdns.io has FOUR rows sharing one name (2x A + 2x AAAA), so each is an
# explicit resource with a distinct label. A for_each keyed on name would
# collide — do not refactor these into one.

resource "routeros_ip_dns_record" "aionios_internal" {
  name    = "aionios.internal"
  type    = "A"
  address = "10.0.20.10"
}

resource "routeros_ip_dns_record" "pihole_internal" {
  name    = "pihole.internal"
  type    = "A"
  address = "192.168.0.9"
}

# NextDNS resolver endpoints — these back the use_doh_server URL above.
# Removing them breaks DoH bootstrap and therefore all resolution.
resource "routeros_ip_dns_record" "nextdns_a1" {
  name    = "dns.nextdns.io"
  type    = "A"
  address = "45.90.28.0"
}

resource "routeros_ip_dns_record" "nextdns_a2" {
  name    = "dns.nextdns.io"
  type    = "A"
  address = "45.90.30.0"
}

resource "routeros_ip_dns_record" "nextdns_aaaa1" {
  name    = "dns.nextdns.io"
  type    = "AAAA"
  address = "2a07:a8c0::"
}

resource "routeros_ip_dns_record" "nextdns_aaaa2" {
  name    = "dns.nextdns.io"
  type    = "AAAA"
  address = "2a07:a8c1::"
}

resource "routeros_ip_dns_record" "palworld_bunny_ac" {
  name    = "palworld.bunny.ac"
  type    = "A"
  address = "10.0.20.246"
}
