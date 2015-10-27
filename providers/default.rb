# Encoding: utf-8
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

include Chef::Mixin::ShellOut
include Chef::Mixin::PowershellOut
include Windows::Domainjoin

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :config do
  if @current_resource.exists
    Chef::Log.info('Domain status already as-requested - nothing to do.')
  else
    converge_by("Create #{@new_resource}") do
      config_domain_membership
      new_resource.updated_by_last_action true
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WinDomain.new(@new_resource.name)
  @current_resource.ou(@new_resource.ou)
  @current_resource.domain(@new_resource.domain)
  @current_resource.membership(@new_resource.membership)
  @current_resource.username(@new_resource.username)
  @current_resource.password(@new_resource.password)
  @current_resource.reboot_delay(@new_resource.reboot_delay)
  @current_resource.exists = config_exists(@current_resource.domain)
end
