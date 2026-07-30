# Faithful import of live state (see MIGRATION-BRIEF.md §7.2): www, ssh and
# winbox are enabled via RouterOS defaults and were absent from the compact
# export. The provider itself talks REST over www/www-ssl — never disable
# both in one apply.
#
# NOTE: routeros_ip_service cannot be imported in provider v1.99.1 (see the
# switch module). These resources are adopted on first apply: the provider's
# create issues "set numbers=<name>" against the existing service row, and
# every value below matches live state, so the apply is a no-op on-device.

resource "routeros_ip_service" "ftp" {
  numbers  = "ftp"
  port     = 21
  disabled = true
}

resource "routeros_ip_service" "ssh" {
  numbers  = "ssh"
  port     = 22
  disabled = false
}

resource "routeros_ip_service" "telnet" {
  numbers  = "telnet"
  port     = 23
  disabled = true
}

resource "routeros_ip_service" "www" {
  numbers  = "www"
  port     = 80
  disabled = false
}

resource "routeros_ip_service" "www_ssl" {
  numbers     = "www-ssl"
  port        = 443
  certificate = routeros_system_certificate.webfig.name
  tls_version = "any"
  disabled    = false
}

resource "routeros_ip_service" "winbox" {
  numbers  = "winbox"
  port     = 8291
  disabled = false
}

resource "routeros_ip_service" "api" {
  numbers  = "api"
  port     = 8728
  disabled = true
}

resource "routeros_ip_service" "api_ssl" {
  numbers     = "api-ssl"
  port        = 8729
  certificate = "none"
  tls_version = "any"
  disabled    = true
}
