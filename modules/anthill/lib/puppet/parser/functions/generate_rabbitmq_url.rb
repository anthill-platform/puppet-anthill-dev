
#
# Arguments: Anthill::Location
#
# this function takes an Anthill::Location resource for a rabbitmq service, and
# generates a amqp location for it


module Puppet::Parser::Functions
  newfunction(:generate_rabbitmq_url, :type => :rvalue) do |args|

    resource = args[0]

    username = resource['username']
    password = resource['password']
    host = resource['host']
    port = resource['port']
    environment = resource['environment']

    return "amqp://#{username}:#{password}@#{host}:#{port}/#{environment}"
  end
end