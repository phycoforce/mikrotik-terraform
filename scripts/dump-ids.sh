#!/usr/bin/env bash
# Dump RouterOS .id values over REST for generating import {} blocks.
# usage: ./dump-ids.sh https://192.168.0.1 terraform '<password>' router
#
# ⚠️  The output contains the PPPoE password when run with the `sensitive`
#     policy. *-ids.json is gitignored — delete the dumps once imports are done.
set -euo pipefail
HOST="$1"; USER="$2"; PASS="$3"; LABEL="$4"

PATHS=(
  /certificate
  /interface/bridge /interface/bridge/port /interface/bridge/vlan
  /interface/ethernet /interface/vlan /interface/list /interface/list/member
  /interface/pppoe-client
  /ip/address /ip/pool /ip/route
  /ip/dhcp-server /ip/dhcp-server/network /ip/dhcp-server/lease
  /ip/dns /ip/dns/static
  /ip/firewall/filter /ip/firewall/nat /ip/firewall/address-list
  /ip/ipsec/profile /ip/service
  /ip/neighbor/discovery-settings /tool/mac-server/mac-winbox
  /ipv6/nd /ipv6/settings
  /routing/bgp/instance /routing/bgp/template /routing/bgp/connection
  /system/identity /system/clock /system/scheduler /system/ntp/client
  /user /user/group
  /tool/sniffer /tool/mac-server
)

for p in "${PATHS[@]}"; do
  echo "===== ${p} ====="
  curl -sk -u "${USER}:${PASS}" "${HOST}/rest${p}" | jq '.' 2>/dev/null || echo "(unavailable)"
done > "${LABEL}-ids.json"
echo "wrote ${LABEL}-ids.json"
