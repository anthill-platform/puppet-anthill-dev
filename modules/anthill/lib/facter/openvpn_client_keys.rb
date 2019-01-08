# Fact: openvpn_<server>_client_keys
#
# Purpose:
#   Returns true if the keys
#        /etc/openvpn/<server>/keys/ca.crt
#        /etc/openvpn/<server>/keys/<server>.key
#        /etc/openvpn/<server>/keys/<server>.crt
#   are in place
#

require 'etc'
require 'facter'

module Facter::OpenvpnClientKeys

  def self.add_facts

    if File.directory?("/etc/openvpn")

        # iterate over /etc/openvpn
        Dir.foreach("/etc/openvpn") do |server_name|
            server_dir = File.join("/etc/openvpn", server_name)
            next if server_name == '.' or server_name == '..' or File.file?(server_dir)
            server_full_dir = File.join(server_dir, "keys")
            if File.directory?(server_full_dir)

                client_ca_dir = File.join(server_full_dir, "ca.crt")
                client_key_dir = File.join(server_full_dir, server_name + ".key")
                client_crt_dir = File.join(server_full_dir, server_name + ".crt")

                if File.file?(client_ca_dir) and File.file?(client_crt_dir) and File.file?(client_key_dir)
                    Facter.add("openvpn_" + server_name + "_client_keys") do
                      setcode { true }
                    end
                end
            end
        end

    end
  end
end

Facter::OpenvpnClientKeys.add_facts
