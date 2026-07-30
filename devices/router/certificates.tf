# Only the two locally-created TLS certificates are managed. The device also
# carries a full imported CA bundle (cacert.pem_*) and auto-generated
# WiFi-CAPsMAN certificates — those stay unmanaged.
#
# Imported as-is; per the v1.99.1 provider docs the sign {} block must be
# omitted when importing existing certificates (ca is read-only; the signing
# relationship lives on the device).
#
# Both certificates were re-issued on-device on 2026-07-30 (the original root
# CA had days_valid=365) and re-imported with their new internal ids.

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
  common_name = "192.168.0.1"
  days_valid  = 3650
  key_size    = "prime256v1"
  key_usage   = ["digital-signature", "key-agreement", "key-cert-sign", "crl-sign", "tls-server"]
  trusted     = true

  depends_on = [routeros_system_certificate.local_root_cert]
}
