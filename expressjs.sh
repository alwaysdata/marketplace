#!/bin/bash

# site:
#     type: nodejs
#     node_version: '12'
#     working_directory: '{INSTALL_PATH}'
#     command: 'node ~{INSTALL_PATH_RELATIVE}/app.js'
#     path_trim: true

set -e

# http://expressjs.com/en/starter/installing.html

npm init -y
npm install express --save

# http://expressjs.com/en/starter/hello-world.html

cat << EOF > app.js
const express = require('express')

const app = express()

app.get('/', function (req, res) {
  res.send('Hello World!')
})

  $(test $(head -c1 /etc/debian_version) == 8 && echo "app.listen(process.env.PORT, '0.0.0.0', function () {" || echo "app.listen(process.env.PORT, function () {")
  console.log('Example app started!')
})
EOF
