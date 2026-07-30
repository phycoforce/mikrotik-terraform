# Copy to terraform.tfvars (gitignored) and fill in, or skip the file entirely
# and export ROS_USERNAME / ROS_PASSWORD in the shell instead.

username = "terraform"
password = "CHANGE-ME"

# Until the local root CA is exported and trusted, TLS verification will fail
# against the self-signed webfig certificate. Either:
#   ca_certificate = "../../local-root-cert.pem"   # preferred
# or:
#   insecure = true                                # temporary fallback
insecure = true
