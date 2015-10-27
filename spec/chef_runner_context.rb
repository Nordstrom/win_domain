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

require 'rspec/core/shared_context'

# this is a 'standard' chef run, with no overrides
module ChefRun
  extend RSpec::Core::SharedContext

  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end
end

# the following are commented out to save memory
# they show how you can set up alternate Chef Runners that
# override the node's chef environment or other attributes
# module ChefRunTestEnv
#   extend RSpec::Core::SharedContext
#
#   let(:chef_run) do
#     ChefSpec::ServerRunner.new do |node, server|
#       server.create_environment('win_domain-test')
#       node.chef_environment = 'win_domain-test'
#       server.create_node(node)
#     end.converge(described_recipe)
#   end
# end
#
# # a chef run where node attributes are overriden
# module ChefRunOverrideAttrs
#   extend RSpec::Core::SharedContext
#
#   let(:chef_run) do
#     ChefSpec::ServerRunner.new do |node|
#       node.set['win_domain']['foobar'] = true
#     end.converge(described_recipe)
#   end
# end
