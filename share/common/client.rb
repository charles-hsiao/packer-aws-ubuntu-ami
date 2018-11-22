
chef_server_url 'CHEF_SERVER'
validation_key '/etc/chef/maicoin-validator.pem'
validation_client_name 'maicoin-validator'
verify_api_cert false
ssl_verify_mode :verify_none
node_name 'CHEF_NODE'
environment 'CHEF_ENV'
interval 1800
log_level :error
log_location  '/var/log/chef/chef.log'

# The whitelist comes from node['role']['push_jobs']['whitelist']
whitelist(
  {
    "sudo" => "chef-client --once -l info --force-logger -o recipe[cerberus::sudo] >> /var/log/chef/sudo.log 2>&1",
  }
)
