# win_domain

## Description

This LWRP cookbook is to provide a tool for full-stack app teams to join arbitrary Windows server instances to an Active Directory
domain.  In order to do so you must possess the following:

* A service account and password with which you can authenticate to Active Directory
* A dedicated Active Directory OU where your service account has permissions to manage computer accounts.
* A secure means of storing/retrieving/managing the account credentials (i.e. use Chef Vault)
* This entry in your chef client.rb file: "node_name ENV['computername']", which must be present when the server is registered in Chef.  This overrides using the FQDN as the node name in Chef, which allows run_list assignment to persist on the node after domain membership is configured.
* Network connectivity to domain controllers for your domain.  See MSFT documentation for details on required network ports/protocols.

    Please cut a WO request to WSE to have a dedicated service account and Active Directory OU created for your team.

## Warning
If this LWRP detects a change in domain membership, it will spawn independent (from the chef run) powershell processes that:

* initiate a reboot, based on supplied delay attribute
* kill the ruby process (aborting the chef run)

    Please ensure you have a mechanism in place that restarts the chef client post-reboot, such as an on-boot scheduled task.

## Attributes

* ou: Organization Unit (String).  Location in Active Directory where machine account is placed
* domain: Name (string) of the domain to be joined
* username (string): Service account username with sufficient permissions to join computers to AD
* password (string): Self-explanatory.  Use secure means such as Chef Vault
* reboot_delay: Number of seconds to delay reboot if membership change is detected.  Default is 30

## Action

* membership (string): 'join' or 'disjoin'.  Self-explanatory.

## Sample Usage with Chef Vault.  Update user credentials appropriately.

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
    end

### Unit Tests

    bin/rake spec

Will run ChefSpec tests.  It is a good idea to ensure that these
tests pass before committing changes to git.

#### Unit Test Coverage

    bin/rake coverage

Will run the ChefSpec tests and report on test coverage.  It is a
good idea to make sure that every Chef resource you declare is covered
by a unit test.

#### Automated Testing with Guard

    bin/guard

Will run foodcritic, tailor, rubocop (if enabled) and chefspec tests
automatically when the associated files change.  If a chefspec test
fails, it will drop you into a pry session in the context of the
failure to explore the state of the run.

To disable the pry-rescue behavior, define the environment variable
DISABLE_PRY_RESCUE before running guard:

    DISABLE_PRY_RESCUE=1 bin/guard

### Integration Tests

    bin/rake kitchen:all

Will run the test kitchen integration tests.  These tests use Vagrant
and Virtualbox, which must be installed for the tests to execute.

After converging in a virtual machine, ServerSpec tests are executed.
This skeleton comes with a very basic ServerSpec test; refer to
http://serverspec.org for detail on how to create tests.

## Author

Dave Viebrock, Nordstrom, Inc.

## License

Copyright (c) 2015 Nordstrom, Inc., All Rights Reserved.
