# win_domain

## Description

This LWRP cookbook joins arbitrary Windows server instances to an Active Directory
domain.  In order to do so you must possess the following:
* Account and password with permissions to join computers to Active Directory
* A secure means of storing/retrieving the account credentials (i.e. use Chef Vault)
* Network connectivity to domain controllers for your domain.  See MSFT documentation for details on required network ports/protocols.
* A means of authorizing the server instance to decrypt the account credentials.


## Attributes

* ou: Organization Unit (String).  Location in Active Directory where machine account is placed.
* domain: Name (string) of the domain to be joined.
* username (string): Service account username with sufficient permissions to join computers to AD.
* password (string): Self-explanatory.  Use secure means such as Chef Vault.

## Action

* membership (string): 'join' or 'disjoin'.  Action to be performed.

## Sample Usage: Using Chef Vault

    <!-- chef_gem 'chef-vault' do
      version '2.6.1'
      options("--clear-sources --source <insert_your_chef_gem_URL_here>")
    end
    require 'chef-vault'

    user_info = ChefVault::Item.load('WsePasswords', 'WseDfsBuilder')
    username = user_info['username']
    password = user_info['password']

    win_domain 'nordstrom.net' do
      ou 'OU=AWS,OU=General,OU=Servers,DC=nordstrom,DC=net'
      domain 'nordstrom.net'
      membership 'join'
      username username
      password password
      notifies :request, 'reboot[10]', :immediately
    end

    reboot '10' do
      reason 'Required by the Chef OS domain joining LWRP'
      action :nothing
    end -->

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
