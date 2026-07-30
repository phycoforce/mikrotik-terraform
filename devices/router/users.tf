# Router users under management. Passwords are never set here: the provider
# leaves the on-device password untouched when the attribute is omitted, and
# the REST API never returns it. The external-dns password lives in the
# cluster's external-dns-internal-secret (SOPS).
#
# Brought under management 2026-07-30: the external-dns webhook provider
# (ghcr.io/mirceanton/external-dns-provider-mikrotik) authenticates as this
# user to manage the 56 "Managed by ExternalDNS" static DNS records.
resource "routeros_system_user" "external_dns" {
  name  = "external-dns"
  group = "write"
}
