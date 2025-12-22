#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '24'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'npx next start --port $PORT --hostname $IP'
#     environment: |
#         HOME={INSTALL_PATH}
# requirements:
#     disk: 600

set -e

export NPM_CONFIG_CACHE=`mktemp -d`
export XDG_CONFIG_HOME=`mktemp -d`

echo "Y"|pnpm create next-app@latest default --yes

cd default

cat << EOF > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  basePath: '',
  reactStrictMode: true,
}

module.exports = nextConfig
EOF

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s,basePath: '',basePath:'$INSTALL_URL_PATH',g" next.config.js
fi

npx next build

# Clean install environment
cd
rm -rf .cache .local
shopt -s dotglob
mv default/* .
rmdir default
