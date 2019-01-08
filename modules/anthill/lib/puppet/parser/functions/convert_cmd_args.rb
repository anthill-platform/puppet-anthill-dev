
module Puppet::Parser::Functions
  newfunction(:convert_cmd_args, :type => :rvalue) do |args|
    args[0].map {
        |key, value|
            (if (value.kind_of?(Array))
                then ("--" + key + "=" + value.map { |item| "\"" + item.to_s + "\"" }.join(","))
                else ("--" + key + "=\"" + value.to_s + "\"")
                end)
    }.join(" ")
  end
end