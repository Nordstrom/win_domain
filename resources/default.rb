# Encoding: utf-8

actions :config
default_action :config

attribute :ou, kind_of: String, required: true, default: 'OU=AWS,OU=Servers,DC=nordstrom,DC=net'
attribute :domain, name_attribute: true, kind_of: String, required: true# , regex: [/^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$/]
attribute :membership, kind_of: String, required: true, default: 'join', equal_to: %w(join disjoin)
attribute :username, kind_of: String, required: true
attribute :password, kind_of: String, required: true

attr_accessor :exists
