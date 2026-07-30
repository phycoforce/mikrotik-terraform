# Switch users under management (imported 2026-07-30). Passwords are managed
# out-of-band on purpose: the provider never reads them back, so a
# Terraform-set password would sit in state/tfvars while providing zero drift
# detection. Set them on-device (`/user set aaron password=...`).
#
# ⚠ SELF-REFERENTIAL: the terraform group/user are the credential this
# provider session authenticates as. Never remove read/write/api/rest-api.
#
# NOTE: modifying ANY /user or /user/group resource requires the `policy`
# right, which this group deliberately lacks today — plans stay clean, but
# edits will fail until the grant documented in README.md is run. After
# granting, add "policy" to the list below in the same change.

resource "routeros_system_user_group" "terraform" {
  name   = "terraform"
  policy = ["reboot", "read", "write", "test", "sensitive", "api", "romon", "rest-api"]
}

resource "routeros_system_user" "terraform" {
  name    = "terraform"
  group   = routeros_system_user_group.terraform.name
  address = "10.0.10.0/24,192.168.0.0/24"
}

resource "routeros_system_user" "aaron" {
  name  = "aaron"
  group = "full"
}
