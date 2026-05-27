resource "routeros_ip_service" "www_ssl" {
  numbers     = "www-ssl"
  port        = 443
  disabled    = false
  certificate = routeros_system_certificate.webfig.name
}