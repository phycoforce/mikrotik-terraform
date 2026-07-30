# ============================================================================
# Wave 7: BGP  —  HIGHEST BLAST RADIUS OF THE MIGRATION
#
# These three connections peer with Cilium in the Kubernetes cluster and carry
# every LoadBalancer IP the cluster advertises, including 10.0.20.249 (internal
# ingress) which 56 DNS records point at. Any parameter write to a live BGP
# connection restarts the session; a restarted session withdraws and re-floods
# the LB prefixes. Nothing in this file may ever produce a plan diff.
#
# Everything below is transcribed from the live REST rows in router-ids.json
# (GET /rest/routing/bgp/{instance,template,connection}, dumped 2026-07-30).
# Only attributes the live rows actually carry are set — nothing speculative.
#
# ---------------------------------------------------------------------------
# Why the ignore_changes blocks exist (read before removing them)
# ---------------------------------------------------------------------------
# Unlike /interface/vlan and friends, RouterOS does NOT return BGP defaults
# over REST — a connection row only lists parameters that were explicitly
# configured. The provider's reader only writes fields it actually receives
# (mikrotik_serialize.go:377 iterates the response, nothing else), so after
# import those attributes land in state as ""/false/0.
#
# The provider schema, however, declares SDK `Default:` values for them
# (resource_routing_bgp_connection.go:77,83,119,311,318,341,391,529). The
# terraform-plugin-sdk config reader substitutes a schema Default whenever an
# Optional attribute is absent from config, so the plan would compare
# "" -> "none", false -> true, 0 -> 179 and want to write all eight back to the
# router. keepalive_time cannot save us either: its TimeEqual suppressor bails
# out early on an empty old value (provider_schema_helpers.go:731-733).
#
# Pinning the values in config does NOT help — the diff is state("") vs
# default("none"), so an explicit `add_path_out = "none"` diffs identically.
# ignore_changes is the only way to reach the required zero-change plan, and it
# is also the correct semantic: these parameters are unset on the router and
# must stay unset. Contrast routeros_tool_sniffer in misc.tf, where the live
# row *did* carry the value and pinning was enough.
#
# Attributes deliberately left alone (verified diff-free, no ignore needed):
#   hold_time, routing_table  Optional+Computed -> absent config is a no-op
#   instance, vrf, disabled   AlwaysPresentNotUserProvided diff suppression
#   input {}, output {}       absent from every live row; empty blocks would
#                             themselves create a diff, so they are omitted
#   templates                 empty on every row (the `default` template is
#                             disabled and referenced by nothing)
# ============================================================================


# ----------------------------------------------------------------------------
# BGP instance — the local side of all three peerings.
# Live row: {".id":"*1","as":"64513","inactive":"false","name":"bgp-instance-1",
#            "vrf":"main"}
# `inactive` is read-only. The row carries no `disabled` and no `routing-table`,
# so both are left unset. No attribute on this resource has a schema Default,
# so it needs no ignore_changes.
# ----------------------------------------------------------------------------
resource "routeros_routing_bgp_instance" "bgp_instance_1" {
  name = "bgp-instance-1"
  as   = "64513"
  vrf  = "main"

  lifecycle {
    prevent_destroy = true
  }
}

# ----------------------------------------------------------------------------
# The built-in `default` BGP template. IMPORTED, NEVER CREATED — RouterOS ships
# this row and it cannot be recreated. It is disabled and no connection
# inherits from it, so it is inert, but it must stay in state untouched.
# Live row: {".id":"*1","as":"65530","default":"true","disabled":"true",
#            "inactive":"true","name":"default","routing-table":"main"}
# `default` and `inactive` are read-only in the schema (PropDefaultRo / Computed).
# Same SDK-Default trap as the connections, on four attributes
# (resource_routing_bgp_template.go:64,70,291,311).
# ----------------------------------------------------------------------------
resource "routeros_routing_bgp_template" "default" {
  name          = "default"
  as            = "65530"
  disabled      = true
  routing_table = "main"

  lifecycle {
    ignore_changes = [
      add_path_out,     # schema Default "none"    — unset on the router
      address_families, # schema Default "ip"      — unset on the router
      keepalive_time,   # schema Default "3m"      — unset on the router
      nexthop_choice,   # schema Default "default" — unset on the router
    ]
  }
}

# ----------------------------------------------------------------------------
# Cilium BGP peers. All three are identical apart from name and remote address.
#
# `as` is Required on this resource (resource_routing_bgp_connection.go:89-91)
# even though the compact export omits it — the connections inherit 64513 from
# bgp-instance-1. Setting it is safe and diff-free because every live row does
# report "as": "64513"; leaving it out is not an option, the schema rejects it.
#
# `vrf = "main"` is likewise not in the compact export but is present on every
# live row, and matching it exactly keeps the plan clean.
# ----------------------------------------------------------------------------

# Live row: {".id":"*11","as":"64513","disabled":"false","inactive":"false",
#            "instance":"bgp-instance-1","local.address":"10.0.20.1",
#            "local.role":"ebgp","name":"logos","remote.address":"10.0.20.2/32",
#            "remote.as":"64514","routing-table":"main","vrf":"main"}
resource "routeros_routing_bgp_connection" "logos" {
  name          = "logos"
  instance      = routeros_routing_bgp_instance.bgp_instance_1.name
  as            = "64513"
  disabled      = false
  routing_table = "main"
  vrf           = "main"

  local {
    address = "10.0.20.1"
    role    = "ebgp"
  }

  remote {
    address = "10.0.20.2/32"
    as      = "64514"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      add_path_out,     # schema Default "none"    — unset on the router
      address_families, # schema Default "ip"      — unset (writes as `afi` on 7.19+)
      connect,          # schema Default true      — unset on the router
      keepalive_time,   # schema Default "3m"      — unset on the router
      listen,           # schema Default true      — unset on the router
      nexthop_choice,   # schema Default "default" — unset on the router
      local[0].port,    # schema Default 179       — unset on the router
      remote[0].port,   # schema Default 179       — unset on the router
    ]
  }
}

# Live row: {".id":"*12","as":"64513","disabled":"false","inactive":"false",
#            "instance":"bgp-instance-1","local.address":"10.0.20.1",
#            "local.role":"ebgp","name":"pneuma","remote.address":"10.0.20.4/32",
#            "remote.as":"64514","routing-table":"main","vrf":"main"}
resource "routeros_routing_bgp_connection" "pneuma" {
  name          = "pneuma"
  instance      = routeros_routing_bgp_instance.bgp_instance_1.name
  as            = "64513"
  disabled      = false
  routing_table = "main"
  vrf           = "main"

  local {
    address = "10.0.20.1"
    role    = "ebgp"
  }

  remote {
    address = "10.0.20.4/32"
    as      = "64514"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      add_path_out,
      address_families,
      connect,
      keepalive_time,
      listen,
      nexthop_choice,
      local[0].port,
      remote[0].port,
    ]
  }
}

# Live row: {".id":"*13","as":"64513","disabled":"false","inactive":"false",
#            "instance":"bgp-instance-1","local.address":"10.0.20.1",
#            "local.role":"ebgp","name":"ontos","remote.address":"10.0.20.3/32",
#            "remote.as":"64514","routing-table":"main","vrf":"main"}
resource "routeros_routing_bgp_connection" "ontos" {
  name          = "ontos"
  instance      = routeros_routing_bgp_instance.bgp_instance_1.name
  as            = "64513"
  disabled      = false
  routing_table = "main"
  vrf           = "main"

  local {
    address = "10.0.20.1"
    role    = "ebgp"
  }

  remote {
    address = "10.0.20.3/32"
    as      = "64514"
  }

  lifecycle {
    prevent_destroy = true

    ignore_changes = [
      add_path_out,
      address_families,
      connect,
      keepalive_time,
      listen,
      nexthop_choice,
      local[0].port,
      remote[0].port,
    ]
  }
}
