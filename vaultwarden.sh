#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'env ROCKET_PORT=$PORT ROCKET_ADDRESS=:: ./vaultwarden'
#     ssl_force: true
# form:
#     admin_password:
#         type: password
#         label:
#             en: Administrator password
#             fr: Mot de passe de l'administrateur
# requirements:
#     disk: 100

set -e

# Download
wget --no-hsts https://raw.githubusercontent.com/jjlin/docker-image-extract/main/docker-image-extract
chmod +x docker-image-extract

./docker-image-extract vaultwarden/server:latest-alpine
mv ./output/{vaultwarden,web-vault} .
rm -rf ./output

# Configuration
mkdir -p data
cat << EOF > data/config.json
{
  "domain": "https://${INSTALL_URL}",
  "admin_token":"$(echo -n $FORM_ADMIN_PASSWORD | argon2 $(openssl rand -base64 32) -e -id -k 19456 -t 2 -p 1)",
  "signups_allowed": true,
  "signups_verify": true,
  "smtp_host": "smtp-${USER}.${RESELLER_DOMAIN}",
  "smtp_from": "${USER}@${RESELLER_DOMAIN}"
}
EOF
