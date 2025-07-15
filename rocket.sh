#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: './target/release/{INSTALL_PATH_RELATIVE}'
#     path_trim: true
#     environment: |
#         CARGO_HOME='{INSTALL_PATH}'
# requirements:
#     disk: 400

set -e

# https://rocket.rs/guide/v0.5/getting-started/#getting-started

cargo init

echo 'rocket = "0.5.1"' >> Cargo.toml

cat << EOF > src/main.rs
#[macro_use] extern crate rocket;

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
EOF

# https://rocket.rs/guide/v0.5/deploying/#containerization

cargo build --release

cat << EOF > Rocket.toml
[release]
port = $PORT
address = "::"
EOF
