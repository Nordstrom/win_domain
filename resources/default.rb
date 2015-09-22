# Encoding: utf-8

actions :config
default_action :config

attribute :OU, kind_of: String, required: true, default: 'OU=AWS,OU=Servers,DC=nordstrom,DC=net'
attribute :domain, kind_of: String, required: true
attribute :membership, kind_of: String, required: true, default: 'join', equal_to: %w(join disjoin)
attribute :username, kind_of: String, required: true
attribute :password, kind_of: String, required: true

attr_accessor :status
