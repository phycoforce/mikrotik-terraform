# Only the two locally-created TLS certificates are managed. The device also
# carries a full imported CA bundle (cacert.pem_*) and auto-generated
# WiFi-CAPsMAN certificates — those stay unmanaged.
#
# Imported as-is; per the v1.99.1 provider docs the sign {} block must be
# omitted when importing existing certificates (ca is read-only; the signing
# relationship lives on the device).
#
# ⚠ local-root-cert was created with days_valid=365 (unlike the switch's
# 3650) — it expires within a year of creation. Flagged in the migration
# report.

resource "routeros_system_certificate" "local_root_cert" {
  name        = "local-root-cert"
  common_name = "local-cert"
  days_valid  = 365
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

  depends_on = [routeros_system_certificate.local_root_cert]
}
