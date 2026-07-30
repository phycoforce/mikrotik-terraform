resource "routeros_system_identity" "identity" {
  name = "Router"
}

resource "routeros_system_clock" "clock" {
  time_zone_name = "Europe/London"
}

# NTP client — added 2026-07-30 per the migration report decision (the router
# previously had no time source beyond the RTC; the switch already syncs to
# pool.ntp.org). This mirrors the switch configuration.
resource "routeros_system_ntp_client" "ntp_client" {
  enabled = true
  servers = ["pool.ntp.org"]
}

# policy trimmed to just `reboot` on-device 2026-07-30 (it only runs
# /system reboot; the WinBox-default policy list was over-privileged and
# blocked the terraform group from managing this row).
resource "routeros_system_scheduler" "scheduled_reboot" {
  name       = "scheduled_reboot"
  on_event   = "/system reboot"
  policy     = ["reboot"]
  start_date = "2026-03-25"
  start_time = "05:30:00"
}
