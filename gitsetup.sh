#!/bin/bash

setup() {
git config --global push.default simple
git config --global user.email "admin@lascalia.com"
git config --global user.name "Jakub Pazdyga user at Docker container"
}

pull() {
cd /tmp
if [ -d ./testapp ];
then
        cd ./testapp
        git pull
else
        git clone https://github.com/jpazdyga/testapp.git
        cd ./testapp
fi
}

#code() {
#
#}

setup
pull

