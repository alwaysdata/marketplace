#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: "java17 -Xmx512m -jar jenkins.war --httpListenAddress=0.0.0.0 --httpPort=$PORT"
#     environment: |
#          JENKINS_HOME={INSTALL_PATH}
# requirements:
#     disk: 75

set -e

wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
rm .wget-hsts
# The rest is GUI - Jenkins blocks POST requests which we need to continue (via the cURL command)
