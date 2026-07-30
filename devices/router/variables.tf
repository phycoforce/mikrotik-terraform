variable "hosturl" {
  type        = string
  default     = "https://192.168.0.1"
  description = "REST endpoint of the router (RB5009UG+S+)."
}

variable "username" {
  type        = string
  default     = null
  sensitive   = true
  description = "RouterOS user for the provider. Falls back to ROS_USERNAME when null."
}

variable "password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Password for the provider user. Falls back to ROS_PASSWORD when null."
}

variable "insecure" {
  type        = bool
  default     = false
  description = "Skip TLS verification. Prefer ca_certificate over enabling this."
}

variable "ca_certificate" {
  type        = string
  default     = null
  description = "Path to the local root CA certificate (PEM) that signed the device's webfig cert."
}

variable "pppoe_password" {
  type        = string
  sensitive   = true
  description = "Vodafone PPPoE password for the Vodafone_PPPOE client interface."
}
