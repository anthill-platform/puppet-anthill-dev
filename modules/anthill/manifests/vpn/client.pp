define anthill::vpn::client (
  $host_name = $name,
  $client_index,
  $server,
  $client_address_a,
  $client_address_b,
  $dev            = undef,
  $proto          = undef
) {
  openvpn::client { $host_name:
    dev => $dev,
    proto => $proto,
    server => $server,
    download_configs_owner => $anthill::ssh_keys_user
  }

  openvpn::client_specific_config { $host_name:
    server => $server,
    ifconfig => "${client_address_a} ${client_address_b}"
  }

  # export keys to the client itself, he should relize them
  # with File <<| tag == "openvpn_${openvpn_service_name}_${client_name}_${client_index}" |>>

  @@file { "openvpn_${client_index}_ca":
    path => "/etc/openvpn/${server}/keys/ca_${client_index}.crt",
    content => $facts["openvpn_${server}_${host_name}_ca"],
    owner => "root",
    ensure => present,
    mode => "0400",
    tag => [ "openvpn_${server}_${host_name}_${client_index}", "env-${environment}" ]
  }

  @@file { "openvpn_${client_index}_crt":
    path => "/etc/openvpn/${server}/keys/${server}_${client_index}.crt",
    content => $facts["openvpn_${server}_${host_name}_crt"],
    owner => "root",
    ensure => present,
    mode => "0400",
    tag => [ "openvpn_${server}_${host_name}_${client_index}", "env-${environment}" ]
  }

  @@file { "openvpn_${client_index}_key":
    path => "/etc/openvpn/${server}/keys/${server}_${client_index}.key",
    content => $facts["openvpn_${server}_${host_name}_key"],
    owner => "root",
    ensure => present,
    mode => "0400",
    tag => [ "openvpn_${server}_${host_name}_${client_index}", "env-${environment}" ]
  }
}