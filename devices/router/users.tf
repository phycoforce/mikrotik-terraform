# Router users under management. Passwords are never set here: the provider
# leaves the on-device password untouched when the attribute is omitted, and
# the REST API never returns it. The external-dns password lives in the
# cluster's external-dns-internal-secret (SOPS).

# Dedicated least-privilege group for the ExternalDNS webhook provider
# (2026-07-30): its only job is managing the static DNS records it owns —
# no ssh/winbox/web/ftp login surfaces, no sensitive, no reboot, no policy.
# `api` must accompany `rest-api`: RouterOS's REST interface executes through
# the API subsystem internally, so rest-api alone yields
# "login failure via api" on every request even with the api SERVICE disabled
# (verified in the router log, 2026-07-30). (RouterOS policies are global,
# not per-menu, so `write` still spans all menus — this is as narrow as
# RouterOS groups go.)
resource "routeros_system_user_group" "external_dns" {
  name   = "external-dns"
  policy = ["read", "write", "api", "rest-api"]
}

# The external-dns webhook provider (ghcr.io/mirceanton/external-dns-provider-
# mikrotik) authenticates as this user to manage the 56 "Managed by
# ExternalDNS" static DNS records. Address-restricted to the three cluster
# node IPs — confirmed to be the source of its requests (firewall rule
# "ExternalDNS REST API from k8s nodes" shows matching traffic).
resource "routeros_system_user" "external_dns" {
  name    = "external-dns"
  group   = routeros_system_user_group.external_dns.name
  address = "10.0.20.2/32,10.0.20.3/32,10.0.20.4/32"
}

# ---------------------------------------------------------------------------
# Terraform's own credential, under management (imported 2026-07-30).
#
# ⚠ SELF-REFERENTIAL: these two resources are the group and user this
# provider session authenticates as. Changing them changes the live
# credential — edit only deliberately, and never remove read/write/api/
# rest-api from the group.
#
# NOTE: modifying ANY /user or /user/group resource requires the `policy`
# right, which this group deliberately lacks today — plans stay clean, but
# edits will fail with "not enough permissions" until the grant documented in
# README.md is run. After granting, add "policy" to the list below in the
# same change.
# ---------------------------------------------------------------------------
resource "routeros_system_user_group" "terraform" {
  name   = "terraform"
  policy = ["reboot", "read", "write", "test", "sensitive", "api", "romon", "rest-api", "policy"]
}

resource "routeros_system_user" "terraform" {
  name    = "terraform"
  group   = routeros_system_user_group.terraform.name
  address = "10.0.10.0/24,192.168.0.0/24"
}

# Passwords are managed out-of-band on purpose: the provider never reads them
# back, so a Terraform-set password would sit in state/tfvars while providing
# zero drift detection. Set them on-device (`/user set aaron password=...`).
resource "routeros_system_user" "aaron" {
  name  = "aaron"
  group = "full"
}
