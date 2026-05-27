variable "mikrotik_host_url" {
  type        = string
  sensitive   = false
  description = "The URL of the MikroTik device."
}

variable "mikrotik_username" {
  type        = string
  sensitive   = true
  description = "The username for accessing the MikroTik device."
}

variable "mikrotik_password" {
  type        = string
  sensitive   = true
  description = "The password for accessing the MikroTik device."
}

variable "mikrotik_insecure" {
  type        = bool
  default     = true
  description = "Whether to allow insecure connections to the MikroTik device."
}

# =================================================================================================
# Certificate settings
# =================================================================================================
variable "certificate_common_name" {
  type        = string
  description = "Common Name (CN) for the device TLS certificate."
}

variable "certificate_organization" {
  type        = string
  default     = ""
  description = "Organization (O) for the device certificate."
}

variable "certificate_key_type" {
  type        = string
  default     = "prime256v1"
  description = "Key type/size for generated certificates (e.g., 'prime256v1', 'secp384r1', '2048', '4096')."
}

variable "certificate_validity_days" {
  type        = number
  default     = 3650
  description = "Validity period for the device certificate in days."

  validation {
    condition     = var.certificate_validity_days > 0
    error_message = "Certificate validity must be greater than 0 days."
  }
}
# =================================================================================================
# IP Services
# =================================================================================================
variable "ip_services" {
  type = map(object({
    enabled = bool
    port    = number
  }))
  default = {
    "api"     = { enabled = false, port = 8728 }
    "api-ssl" = { enabled = false, port = 8729 }
    "ftp"     = { enabled = false, port = 21 }
    "ssh"     = { enabled = true, port = 22 }
    "telnet"  = { enabled = false, port = 23 }
    "winbox"  = { enabled = true, port = 8291 }
    "www"     = { enabled = true, port = 80 }
    "www-ssl" = { enabled = true, port = 443 }
  }
  description = "Map of IP services to configure. Each service has an 'enabled' flag and a 'port' number. TLS services (api-ssl, www-ssl) automatically use the device certificate."
  validation {
    condition = alltrue([
      for name, svc in var.ip_services : svc.port > 0 && svc.port <= 65535
    ])
    error_message = "All service ports must be between 1 and 65535."
  }
}
variable "tls_version" {
  type        = string
  default     = "any"
  description = "TLS version to use for SSL-enabled IP services (api-ssl, www-ssl)."
  validation {
    condition     = contains(["only-1.2", "only-1.0", "any"], var.tls_version)
    error_message = "TLS version must be one of: only-1.2, only-1.0, any."
  }
}

# =================================================================================================
# Bridge settings
# =================================================================================================
variable "bridge_name" {
  type        = string
  default     = "BR1"
  description = "Name of the main bridge interface."
}

variable "bridge_comment" {
  type        = string
  default     = ""
  description = "Comment for the bridge interface."
}

variable "bridge_mtu" {
  type        = number
  default     = null
  description = "MTU for the bridge interface."
}

variable "bridge_vlan_filtering" {
  type        = bool
  default     = true
  description = "Whether to enable VLAN filtering on the bridge."
}
