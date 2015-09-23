#
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'spec_helper'

describe command(current_resolvers == desired_resolvers) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^true/) }
end
