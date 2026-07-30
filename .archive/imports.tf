# =================================================================================================
# Certificate Imports
# =================================================================================================

import {
  to = routeros_system_certificate.local-root-ca-cert
  id = "*98"
}
import {
  to = routeros_system_certificate.webfig
  id = "*9D"
}

# =================================================================================================
# System Imports
# =================================================================================================
import {
  to = routeros_system_identity.identity
  id = "."
}
import {
  to = routeros_system_clock.set
  id = "."
}
import {
  to = routeros_ipv6_settings.settings
  id = "."
}
import {
  to = routeros_ip_firewall_connection_tracking.set
  id = "."
}