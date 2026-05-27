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
# Bridge Imports
# =================================================================================================
import {
  to = routeros_interface_bridge.bridge
  id = "*A"
}

  import {
  for_each = {
    "ether1"       = { id = "*0" }
    "ether3"       = { id = "*1" }
    "ether4"       = { id = "*2" }
    "ether5"       = { id = "*3" }
    "ether6"       = { id = "*4" }
    "ether7"       = { id = "*5" }
    "ether8"       = { id = "*6" }
    "sfp-sfpplus1" = { id = "*7" }
  }
  to = routeros_interface_bridge_port.bridge_ports[each.key]
  id = each.value.id
}
