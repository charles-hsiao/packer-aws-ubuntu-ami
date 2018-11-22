#!/bin/bash

set -e

sudo apt-get install -y ntp
sudo apt-get install -y ntpdate
sudo apt-get install -y ntp-doc
sudo sed -i s/ubuntu.pool.ntp.org/amazon.pool.ntp.org/g /etc/ntp.conf
sudo update-rc.d ntp defaults
