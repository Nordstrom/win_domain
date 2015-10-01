# chef_gem 'chef-vault' do
#   version '2.6.1'
#   options("--clear-sources --source #{node['wse_base']['gemserver']}")
#   compile_time true
# end
# require 'chef-vault'
#
# user_info = ChefVault::Item.load('WsePasswords', 'WseServerBuilder')
# username = user_info['username']
# password = user_info['password']

# this password was immediately reset, but had to be here for spec tests to
# pass...  :-/
win_domain 'nordstrom.net' do
  ou 'OU=Test,OU=Servers,DC=nordstrom,DC=net'
  domain 'nordstrom.net'
  membership 'join'
  username 'WseServerBuilder'
  password '27Puk3ofA3uMg98iWxII'
  reboot_delay 10
end
