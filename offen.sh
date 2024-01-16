#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
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
#     name:
#         label:
#             en: Account name
#             fr: Nom du compte
#     password:
#         type: password
#         label:
#             en: Login password
#             fr: Mot de passe identifiant
#         min_length: 8
#         max_length: 255

set -e

wget -O-  --no-hsts https://github.com/offen/offen/releases/download/v1.3.4/offen-v1.3.4.tar.gz | tar -xz --strip-components=0

rm -rf offen-darwin* offen-linux-arm* offen-windows*

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
