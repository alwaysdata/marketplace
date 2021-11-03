#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '~{INSTALL_PATH_RELATIVE}/hello'
#     path_trim: true
# requirements:
#     disk: 15

set -e

export GOPATH=$INSTALL_PATH

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

rm -rf pkg src hello.go
