#!/bin/bash

# site:
#     type: nodejs
#     nodejs_version: '14'
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

 app.listen(process.env.PORT, function () {
  console.log('Example app started!')
})
EOF
