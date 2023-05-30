#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npx next start --port $PORT --hostname $IP'
# requirements:
#     disk: 360

set -e

export NPM_CONFIG_CACHE=`mktemp -d`
export XDG_CONFIG_HOME=`mktemp -d`

# Do NOT use `npx` cause it triggers the `.npm-packages missing` bug
# @see https://github.com/npm/cli/issues/5942
npm create -y --force next-app -- \
    --use-npm \
    --typescript \
    --tailwind \
    --eslint \
    --no-app \
    --src-dir \
    --import-alias='@/*' \
    $INSTALL_PATH

cat << EOF > next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  basePath: '',
  reactStrictMode: true,
  experimental: {
    appDir: false
  }
}

module.exports = nextConfig
EOF

if [ "$INSTALL_URL_PATH" != "/" ]
then
    sed -i "s,basePath: '',basePath:'$INSTALL_URL_PATH',g" next.config.js
    sed -i 's,src=",src="'$INSTALL_URL_PATH',g' src/pages/index.tsx
fi

npx next build