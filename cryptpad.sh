#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '18'
#     working_directory: '{INSTALL_PATH}/cryptpad'
#     command: 'node server.js'
#     ssl: true
# requirements:
#     disk: 1400

set -e

npm install bower

git clone --depth 1 https://github.com/xwiki-labs/cryptpad.git cryptpad

cd cryptpad
npm install
$HOME/node_modules/bower/bin/bower install

mv config/config.example.js config/config.js
sed -i "s|http://localhost:3000|https://$INSTALL_URL|" config/config.js
sed -i 's|// httpSafeOrigin: "https://some-other-domain.xyz"|httpSafeOrigin: "https://$INSTALL_URL"|' config/config.js
sed -i "s|\ \ \ \ //httpAddress: '::',|\ \ \ \ httpAddress: '::',|" config/config.js
sed -i "s|\ \ \ \ //httpPort: 3000,|\ \ \ \ httpPort: $PORT,|" config/config.js

# It is necessary to make the checkup via https://$INSTALL_URL/checkup first to adapt config
