#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'env/bin/radicale --config=config'
#     ssl_force: true
# requirements:
#     disk: 30
# form:
#     username:
#         label:
#             en: Username
#             fr: Nom d'utilisateur
#         max_length: 255
#     password:
#         type: password
#         label:
#             en: Password
#             fr: Mot de passe
#         max_length: 255

set -e

# https://radicale.org/v3.html

PYTHON_VERSION='3.12'

# Create a virtualenv and install Radicale in it
python -m venv env
source env/bin/activate

python -m pip install radicale
mkdir -p collections/collection-root

htpasswd -b -c users $FORM_USERNAME $FORM_PASSWORD


# Configuration
cat << EOF > config
# https://radicale.org/v3.html#configuration

[server]
hosts = [::]:$PORT

[auth]
type = htpasswd
htpasswd_filename = $INSTALL_PATH/users
htpasswd_encryption = autodetect

[storage]
filesystem_folder = $INSTALL_PATH/collections
EOF
