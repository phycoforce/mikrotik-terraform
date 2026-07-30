# Firewall NAT — 4 static rules: one srcnat masquerade and three dstnat
# port-forwards.
#
# Ordinal, like firewall.tf: the on-device order is asserted by the
# routeros_move_items resource at the bottom of this file. Adding, removing or
# reordering a resource here means the `sequence` list MUST be updated too.
# There is no terminal rule in either NAT chain, so a mis-order here is less
# dangerous than in firewall.tf — but the three dstnat rules match on disjoint
# ports, so their relative order is not load-bearing today and must not be
# relied on tomorrow.
#
# Every rule is imported by its RouterOS internal .id (see imports.tf). No
# dynamic rows exist in this menu on the live device.
#
# `log` is false on all four live rows and is omitted (the provider suppresses
# the diff for attributes the user did not set). log-prefix is empty on all
# four and is likewise omitted.

# 1 — the only srcnat rule. Masquerades everything leaving via the WAN list.
resource "routeros_ip_firewall_nat" "srcnat_masquerade" {
  chain              = "srcnat"
  action             = "masquerade"
  comment            = "Default masquerade"
  out_interface_list = routeros_interface_list.wan.name
}

# 2 — pairs with the "SoulSeek" filter rule in firewall.tf, which accepts the
# forwarded traffic once this rule has rewritten the destination.
resource "routeros_ip_firewall_nat" "dstnat_soulseek" {
  chain             = "dstnat"
  action            = "dst-nat"
  comment           = "SoulSeek"
  dst_port          = "50300"
  in_interface_list = routeros_interface_list.wan.name
  protocol          = "tcp"
  to_addresses      = "10.0.20.244"
  to_ports          = "50300"
}

# 3 — pairs with the "palworld udp" filter rule, which matches
# connection_nat_state = "dstnat" rather than an interface.
# Note the comment on the device is "palworld-udp" (hyphen) here while the
# filter rule is "palworld udp" (space). Both are transcribed as-is.
resource "routeros_ip_firewall_nat" "dstnat_palworld" {
  chain             = "dstnat"
  action            = "dst-nat"
  comment           = "palworld-udp"
  dst_port          = "8211"
  in_interface_list = routeros_interface_list.wan.name
  protocol          = "udp"
  to_addresses      = "10.0.20.246"
  to_ports          = "8211"
}

# The dead "Plex (Temporary)" rule (disabled, forwarding to the nonexistent
# 10.0.60.15) was removed on 2026-07-30 per the migration report decision.

# ---------------------------------------------------------------------------
# NAT rule order
# ---------------------------------------------------------------------------
#
# Same mechanics as the filter move_items — see the long note in firewall.tf
# for the source-verified behaviour. In short: the first three ids are moved to
# sit immediately before the last id, the last id is the anchor and its own
# absolute position is not asserted, and the read no-ops when the device order
# already matches.
#
resource "routeros_move_items" "firewall_nat_order" {
  resource_path = "/ip/firewall/nat"

  sequence = [
    routeros_ip_firewall_nat.srcnat_masquerade.id, # 1
    routeros_ip_firewall_nat.dstnat_soulseek.id,   # 2
    routeros_ip_firewall_nat.dstnat_palworld.id    # 3 (anchor)
  ]

  depends_on = [
    routeros_ip_firewall_nat.srcnat_masquerade,
    routeros_ip_firewall_nat.dstnat_soulseek,
    routeros_ip_firewall_nat.dstnat_palworld,
  ]
}
