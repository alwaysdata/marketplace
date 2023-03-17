#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npx next start --port $PORT --hostname $IP'
# requirements:
#     disk: 360

set -e

export NPM_CONFIG_CACHE=$(mktemp -d)
export XDG_CONFIG_HOME=$(mktemp -d)

npm create -y --force next-app -- \
    --use-npm \
    --experimental-app \
    --import-alias='@/*' \
    --typescript \
    --eslint \
    --src-dir $INSTALL_PATH

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i '/nextConfig = {$/ a \ \ basePath: "'"$INSTALL_URL_PATH"'",' next.config.js
    sed -i 's,src=",src="'"$INSTALL_URL_PATH"',g' src/app/page.tsx
fi

npx next build