chef_gem 'chef-vault' do
  version '2.6.1'
  options("--clear-sources --source #{node['wse_base']['gemserver']}")
  compile_time true
end
require 'chef-vault'

user_info = ChefVault::Item.load('WsePasswords', 'WseServerBuilder')
username = user_info['username']
password = user_info['password']

win_domain 'nordstrom.net' do
  ou 'OU=Test,OU=Servers,DC=nordstrom,DC=net'
  domain 'nordstrom.net'
  membership 'join'
  username username
  password password
  reboot_delay 10
  reason 'because win_domain said so....'
end
