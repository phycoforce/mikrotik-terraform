# Both certificates already exist on the device (created manually) and are
# imported as-is. Per the v1.99.1 provider docs, the sign {} block must be
# omitted when importing the current state of a certificate — the signing
# relationship (webfig signed by local-root-cert) lives on the device; the
# `ca` attribute is read-only.

resource "routeros_system_certificate" "local_root_cert" {
  name        = "local-root-cert"
  common_name = "local-cert"
  days_valid  = 3650
  key_size    = "prime256v1"
  key_usage   = ["key-cert-sign", "crl-sign"]
  trusted     = true
}

resource "routeros_system_certificate" "webfig" {
  name        = "webfig"
  common_name = "EdgeSwitch"
  days_valid  = 3650
  key_size    = "prime256v1"
  key_usage   = ["digital-signature", "key-agreement", "key-cert-sign", "crl-sign", "tls-server"]
  trusted     = true

  depends_on = [routeros_system_certificate.local_root_cert]
}

