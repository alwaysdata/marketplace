#!/bin/bash

# site:
#     type: user_program
#     working_directory: '{INSTALL_PATH}'
#     command: '/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -Djava.net.preferIPv4Stack=true -Xmx512m -jar jenkins.war --httpListenAddress=0.0.0.0 --httpPort=$PORT'

set -e

wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war
# The rest is GUI - Jenkins blocks POST requests which we need to continue (via the cURL command)
