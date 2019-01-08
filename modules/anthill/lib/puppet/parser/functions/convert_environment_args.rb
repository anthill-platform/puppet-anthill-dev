
module Puppet::Parser::Functions
  newfunction(:convert_environment_args, :type => :rvalue) do |args|
    args[0].map {
        |key, value|
            key + "=\"" + value.to_s + "\""
    }.join(",")
  end
end