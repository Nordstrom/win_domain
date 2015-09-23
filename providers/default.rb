# Encoding: utf-8
# Author:: Dave Viebrock (<dave.viebrock@nordstrom.com>)
# Cookbook Name:: win_domain
# Provider:: win_domain
#

include Chef::Mixin::ShellOut
include Chef::Mixin::PowershellOut
include Windows::Helper
include Windows::Domainjoin

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :join do
  if @current_resource.exists
    Chef::Log.info('Already joined domain - nothing to do.')
  else
    converge_by("Create #{@new_resource}") do
      join_domain
      new_resource.updated_by_last_action true
    end
  end
end


action :disjoin do
  if @current_resource.exists
    Chef::Log.info('Already disjoined domain - nothing to do.')
  else
    converge_by("Create #{@new_resource}") do
      disjoin_domain
      new_resource.updated_by_last_action true
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WinDomainjoin.new(@new_resource.name)
  @current_resource.ou(@new_resource.ou)
  @current_resource.domain(@new_resource.domain)
  @current_resource.membership(@new_resource.membership)
  @current_resource.username(@new_resource.username)
  @current_resource.password(@new_resource.password)
  @current_resource.exists = config_exists(@current_resource.domain)
end
