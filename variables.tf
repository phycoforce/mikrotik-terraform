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