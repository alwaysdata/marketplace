#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: 'env ROCKET_PORT=$PORT ROCKET_ADDRESS=:: ./vaultwarden'
#     ssl_force: true
# requirements:
#     disk: 100

set -e

wget https://raw.githubusercontent.com/jjlin/docker-image-extract/main/docker-image-extract
chmod +x docker-image-extract

./docker-image-extract vaultwarden/server:latest-alpine
mv ./output/{vaultwarden,web-vault} .
rm -rf ./output

mkdir -p data
cat << EOF > data/config.json
{
  "domain": "https://${INSTALL_URL}",
  "signups_allowed": true,
  "signups_verify": true,
  "smtp_host": "smtp-${USER}.alwaysdata.net",
  "smtp_security": "off",
  "smtp_port": 25,
  "smtp_from": "${USER}@${RESELLER_DOMAIN}"
}
EOF
