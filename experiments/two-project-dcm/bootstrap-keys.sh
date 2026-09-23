#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 SECURE_KEY_DIRECTORY" >&2
  exit 2
fi

key_dir=$1
install -d -m 700 "$key_dir"
umask 077

for identity in \
  FOUNDATION:BLZ_DCMX_4X6_FOUNDATION_USER \
  DOMAIN:BLZ_DCMX_4X6_DOMAIN_USER \
  CONSUMER:BLZ_DCMX_4X6_CONSUMER_USER \
  UNRELATED:BLZ_DCMX_4X6_UNRELATED_USER
do
  label=${identity%%:*}
  user=${identity#*:}
  key="$key_dir/$label.p8"
  openssl genrsa -out "$key" 2048 2>/dev/null
  public_key=$(openssl rsa -in "$key" -pubout -outform DER 2>/dev/null | openssl base64 -A)
  snow sql -c blizzard-hq --role ACCOUNTADMIN --secondary-roles NONE --silent \
    -q "ALTER USER $user SET RSA_PUBLIC_KEY='$public_key'" >/dev/null
done

echo "Created four mode-600 private keys in $key_dir; no private key was printed."
