#!/bin/bash

# Declare site in YAML, as documented on the documentation: https://help.alwaysdata.com/en/marketplace/build-application-script/
# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH_RELATIVE}'
#     command: "java17 -Xmx512m -jar jenkins.war --httpListenAddress=0.0.0.0 --httpPort=$PORT"
#     environment: |
#          JENKINS_HOME={INSTALL_PATH}
# requirements:
#     disk: 75

set -e

wget --no-hsts https://get.jenkins.io/war-stable/2.528.2/jenkins.war
