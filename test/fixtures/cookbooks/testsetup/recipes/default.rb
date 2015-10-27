# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# uncomment and update the following when using in your environment

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
#
# win_domain 'nordstrom.net' do
#   ou 'OU=Test,OU=Servers,DC=nordstrom,DC=net'
#   domain 'nordstrom.net'
#   membership 'join'
#   username username
#   password password
#   reboot_delay 10
# end
