#!/bin/bash

set -e

sudo apt-get -y install python-pip

sudo pip install --ignore-installed -U pip
sudo pip install --no-cache-dir awscli --ignore-installed awscli
