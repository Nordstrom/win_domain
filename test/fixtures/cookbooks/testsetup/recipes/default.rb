chef_gem 'chef-vault' do
  version '2.6.1'
  options("--clear-sources --source #{node['wse_base']['gemserver']}")
end
require 'chef-vault'

user_info = ChefVault::Item.load('WsePasswords', 'WsePspBuilder')
username = user_info['username']
password = user_info['password']

win_domain 'nordstrom.net' do
  ou 'OU=General,OU=Servers,DC=nordstrom,DC=net'
  domain 'nordstrom.net'
  membership 'join'
  username username
  password password
  notifies :request, 'reboot[10]', :immediately
end

reboot '10' do
  reason 'Required by the Chef OS domain joining LWRP'
  action :nothing
end
