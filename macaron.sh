#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './hello'
#     path_trim: true
# requirements:
#     disk: 25

set -e

go mod init hello
go mod tidy

# https://go-macaron.com/docs/intro/getting_started

go get gopkg.in/macaron.v1

cat << EOF > hello.go
package main

import (
    "os"
    "gopkg.in/macaron.v1" 
)

func main() { 
    m := macaron.Classic()    
    m.Get("/", func() string {
        return "Hello world!"
    })

    m.Run(os.Getenv("0.0.0.0"), os.Getenv("PORT"))
}
EOF

go build hello.go

chmod -R 755 go

# Clean install environment
rm -rf pkg .cache go go.mod go.sum hello.go
