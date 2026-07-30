terraform {
  required_version = ">= 1.12.0"
  required_providers {
    routeros = {
      source  = "terraform-routeros/routeros"
      version = "1.99.1"
    }
  }
}

# The provider speaks REST over the www/www-ssl service (not api/api-ssl).
# Credentials: set username/password in terraform.tfvars (gitignored), or
# leave them unset and export ROS_USERNAME / ROS_PASSWORD instead.
provider "routeros" {
  hosturl        = var.hosturl
  username       = var.username
  password       = var.password
  insecure       = var.insecure
  ca_certificate = var.ca_certificate
}
