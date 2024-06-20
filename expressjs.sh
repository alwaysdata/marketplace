#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: nodejs
#     nodejs_version: '20'
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: 'node ./app.js'
#     path_trim: true
# requirements:
#     disk: 5

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

 app.listen(process.env.PORT, function () {
  console.log('Example app started!')
})
EOF
