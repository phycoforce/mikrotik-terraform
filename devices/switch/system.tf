resource "routeros_system_identity" "identity" {
  name = "EdgeSwitch"
}

resource "routeros_system_clock" "clock" {
  time_zone_name = "Europe/London"
}

resource "routeros_system_ntp_client" "ntp_client" {
  enabled = true
  servers = ["pool.ntp.org"]
}

resource "routeros_system_routerboard_settings" "routerboard" {
  enter_setup_on = "delete-key"
}

resource "routeros_system_scheduler" "scheduled_reboot" {
  name       = "scheduled_reboot"
  on_event   = "/system reboot"
  policy     = ["ftp", "reboot", "read", "write", "policy", "test", "password", "sniff", "sensitive", "romon"]
  start_date = "2026-03-26"
  start_time = "05:00:00"
}

