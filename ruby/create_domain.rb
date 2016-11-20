#!/usr/bin/env ruby

# Usage Sandbox: create_domain.rb example.com
# Usage Prod: create_domain.rb example.com

require 'pp'
require 'dnsimple'
require_relative 'token'

base_url =  'https://api.sandbox.dnsimple.com'
ARGV.each do |arg|
  base_url = nil if arg.downcase == 'prod' || arg.downcase == 'production'
end

# Construct a client instance.
#
# If you want to connect to production, add command argument `prod` before the domain argument.
client = Dnsimple::Client.new(base_url: base_url, access_token: TOKEN)

# All calls to client pass through a service. In this case, `client.identity` is the identity service.
#
# Dnsimple::Client::Identity#whoami is the method for retrieving the account details for your
# current credentials via the DNSimple API.
response = client.identity.whoami

# The response object returned by any API method includes a `data` attribute. Underneath that
# attribute is an attribute for each data object returned. In this case, `#account` provides
# access to the resulting account object.
#
# Here the account ID is extracted for use in the call to create domain.
account_id = response.data.account.id

name = ARGV.last
puts "Creating domain #{name}"

# Dnsimple::Client::Domains#create_domain is the method for a new domain in DNSimple. Note that this
# does not register the domain, it simply adds the domain for management and DNS service.
response = client.domains.create_domain(account_id, name: name)

# Pretty-print the entire response object so you can see what is inside.
pp response
