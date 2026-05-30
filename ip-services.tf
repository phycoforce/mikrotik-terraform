# =================================================================================================
# IP Services Configuration
# https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_service
# =================================================================================================
resource "routeros_ip_service" "disabled" {
  for_each = { "api" = 8728, "ftp" = 21, "telnet" = 23, "api-ssl" = 8729 }
  numbers  = each.key
  port     = each.value
  disabled = true
}
resource "routeros_ip_service" "enabled" {
  for_each = { "winbox" = 8291, "ssh" = 22, "www" = 80, "reverse-proxy" = 443 }
  numbers  = each.key
  port     = each.value
  disabled = false
}
resource "routeros_ip_service" "ssl" {
  for_each    = { "www-ssl" = 443 }
  numbers     = each.key
  port        = each.value
  tls_version = "any"
  certificate = routeros_system_certificate.webfig.name
  disabled    = false
}