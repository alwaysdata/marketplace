#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '16'
#     working_directory: '{INSTALL_PATH}'
#     command: 'npm run dev'
#     environment: HOME={INSTALL_PATH}
# requirements:
#     disk: 150

set -e

echo "y"|npx create-next-app nextjs-project --use-npm --example "https://github.com/vercel/next-learn/tree/master/basics/learn-starter"


if [ "$INSTALL_URL_PATH" != "/" ]
then
cat << EOF > next.config.js
module.exports = {
  basePath: '$INSTALL_URL_PATH',
}
EOF
fi

rm -rf  .npm
shopt -s dotglob
mv nextjs-project/* .
rmdir nextjs-project
