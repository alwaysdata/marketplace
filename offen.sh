#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './offen-linux-amd64'
# database:
#     type: postgresql
# requirements:
#     disk: 50
# form:
#     email:
#         type: email
#         label:
#             en: Login email
#             fr: Email identifiant
#         max_length: 255
#     name:
#         label:
#             en: Account name
#             fr: Nom du compte
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Login password
#             fr: Mot de passe identifiant
#         min_length: 8
#         max_length: 255

set -e

# Download
wget -O-  --no-hsts https://github.com/offen/offen/releases/download/v1.4.2/offen-v1.4.2.tar.gz | tar -xz --strip-components=0

rm -rf offen-darwin* offen-linux-arm* offen-windows*

# Configuration
# https://docs.offen.dev/running-offen/configuring-the-application/
cat << EOF > offen.env
OFFEN_SERVER_PORT="$PORT"
OFFEN_DATABASE_DIALECT="postgres"
OFFEN_DATABASE_CONNECTIONSTRING=postgres://$DATABASE_USERNAME:$DATABASE_PASSWORD@$DATABASE_HOST:5432/$DATABASE_NAME?sslmode=disable
OFFEN_SMTP_HOST=$SMTP_HOST
OFFEN_SMTP_SENDER=$USER@$RESELLER_DOMAIN
EOF

./offen-linux-amd64 setup -name $FORM_NAME -password $FORM_PASSWORD -email $FORM_EMAIL

# The instance needs to use the same domain but a different subdomain than the website for which it collects datas, and it does not handle subpath: https://docs.offen.dev/running-offen/setting-up-using-subdomains/
