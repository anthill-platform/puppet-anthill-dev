
class anthill::index::repos inherits anthill::index {

  concat { $repos_location:
    ensure => $ensure,
    owner  => $anthill::applications_user,
    group  => $anthill::applications_group,
    mode   => '0400',
    require => File[$anthill::index_location],
  } ~> Service[$service_name]

  concat::fragment { "anthill_index_header":
    target => $repos_location,
    content => "repositories:\n",
    order => "0_header",
  }

  if defined( Class['anthill::keys']) and $anthill::keys::ssh_private_key {
    $fixed_ssh_key = regsubst($anthill::keys::ssh_private_key, "\n", "\n      ", 'G')
    concat::fragment { "anthill_index_default_ssh_key":
      target => $repos_location,
      content => "default_ssh_key: |\n ${fixed_ssh_key}",
      order => "7_default_ssh_key",
    }
  }
}