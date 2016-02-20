#!/bin/bash

FIP=$1

if [[ -z "$FIP" ]]; then
  echo "usage: $0 <gm-floating-ip>"
  exit 1
fi

ping -c 1 $FIP 1>/dev/null 2>&1
wait=$?
while [ "$wait" -ne "0" ]
do
  echo $(date): Could not ping $FIP yet...waiting...
  sleep 15
  ping -c 1 $FIP 1>/dev/null 2>&1
  wait=$?
done

echo
echo $(date): Ping $FIP successful.
echo

echo | openssl s_client -connect $FIP:443 >/dev/null 2>&1
wait=$?
while [ "$wait" -ne "0" ]
do
  echo $(date): Could not download certificate...waiting...
  sleep 15
  echo | openssl s_client -connect $FIP:443 >/dev/null 2>&1
  wait=$?
done

echo $(date): Downloading certificate for use in member join
echo
echo | openssl s_client -connect $FIP:443 2>/dev/null | openssl x509 | tr -d \\n > gm.cert
echo $(date): Stored in gm.cert

echo "Adding a default nsgroup..."

echo $(curl -sk -u admin:infoblox -X POST -H "Content-Type: application/json" -d '{"name": "default", "is_grid_default": true}' https://$FIP/wapi/v2.3/nsgroup)
