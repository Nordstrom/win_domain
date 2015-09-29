#
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'spec_helper'

describe command('netdom verify $env:computername') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/The command completed successfully/) }
end
