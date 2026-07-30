# Switch users under management (imported 2026-07-30). Passwords are managed
# out-of-band on purpose: the provider never reads them back, so a
# Terraform-set password would sit in state/tfvars while providing zero drift
# detection. Set them on-device (`/user set aaron password=...`).
#
# ⚠ SELF-REFERENTIAL: the terraform group/user are the credential this
# provider session authenticates as. Never remove read/write/api/rest-api.
#
# NOTE: modifying ANY /user or /user/group resource requires the `policy`
# right. It was granted on-device on 2026-07-30 (the "allow group/user
# provision" change) but only codified here on the same day's post-migration
# audit — the router module had codified it immediately; this closes the gap.

resource "routeros_system_user_group" "terraform" {
  name   = "terraform"
  policy = ["reboot", "read", "write", "test", "sensitive", "api", "romon", "rest-api", "policy"]
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

# Factory default admin account, disabled on day one and kept under management
# (2026-07-30 audit) so a re-enable — hand edit, config restore, netinstall —
# shows up as drift instead of silently restoring an admin login.
resource "routeros_system_user" "admin" {
  name     = "admin"
  group    = "full"
  comment  = "system default user"
  disabled = true
}
