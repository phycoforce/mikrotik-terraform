# Vodafone PPPoE WAN link — rides the VODAFONE_VLAN (911) on ether2 (ONT).
# The password comes from terraform.tfvars (gitignored); the REST import also
# returns it (terraform user has the `sensitive` policy), so state and config
# agree and no write occurs on adoption.

resource "routeros_interface_pppoe_client" "vodafone" {
  name              = "Vodafone_PPPOE"
  interface         = routeros_interface_vlan.vodafone_vlan.name
  user              = "dsl003367638@broadband.vodafone.co.uk"
  password          = var.pppoe_password
  add_default_route = true
  use_peer_dns      = true
  disabled          = false

  # This is the only WAN link — destroying it cuts internet for the network.
  lifecycle { prevent_destroy = true }
}
