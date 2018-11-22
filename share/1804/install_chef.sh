#!/bin/bash

set -e

sudo apt-get update
# Ignore interactive mode
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
curl -L https://omnitruck.chef.io/install.sh | sudo bash -s -- -v 13.6.4

sudo rm -rf /usr/bin/chef-client
sudo link /opt/chef/bin/chef-client /usr/bin/chef-client

# Create chef config folder
sudo rm -rf /etc/chef
sudo mkdir /etc/chef

# Create chef log folder
sudo rm -rf /var/log/chef
sudo mkdir /var/log/chef

sudo mv /tmp/client.rb /etc/chef/client.rb
sudo mv /tmp/role.js /etc/chef/role.js

sudo chown root:root /etc/chef/client.rb
sudo chown root:root /etc/chef/role.js

sudo chmod 644 /etc/chef/client.rb
sudo chmod 644 /etc/chef/role.js
