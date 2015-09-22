chef_gem 'chef-vault' do
  version '2.6.1'
  options("--clear-sources --source <insert_your_chef_gem_URL_here>")
end
require 'chef-vault'

user_info = ChefVault::Item.load('<vault_name>', 'user_name')
password = user_info['password']


win_domain 'your_domain_name' do
  ou '<OU where computer account will be created>'
  domain = 'your_domain_name'
  membership 'join' (default, or 'disjoin')
  username '<user_name>'
  password '<password>'
  notifies :request, 'reboot[10]', :immediately
end

reboot '10' do
  reason 'Required by the Chef OS domain joining LWRP'
  action :nothing
end
