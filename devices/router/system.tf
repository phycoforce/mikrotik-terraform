resource "routeros_system_identity" "identity" {
  name = "Router"
}

resource "routeros_system_clock" "clock" {
  time_zone_name = "Europe/London"
}

# NOTE: the NTP client is deliberately NOT managed — it is unconfigured on the
# router (enabled=false, no servers) while the switch syncs to pool.ntp.org.
# Probable oversight; flagged in the migration report as a follow-up decision.

resource "routeros_system_scheduler" "scheduled_reboot" {
  name       = "scheduled_reboot"
  on_event   = "/system reboot"
  policy     = ["ftp", "reboot", "read", "write", "policy", "test", "password", "sniff", "sensitive", "romon"]
  start_date = "2026-03-25"
  start_time = "05:30:00"
}
