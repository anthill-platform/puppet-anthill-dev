
class anthill::install inherits anthill {

  group { $applications_group:
    ensure           => 'present'
  } -> user { $applications_user:
    ensure           => 'present',
    gid              => $applications_group,
    home             => "/home/${applications_user}",
    shell            => '/bin/bash',
    password         => $applications_user_password
  } -> file { "/home/${applications_user}":
    ensure => 'directory',
    owner  => $applications_user,
    mode   => '0750'
  } -> file { $applications_location:
    ensure => 'directory',
    owner  => 'root',
    group => $applications_group,
    mode   => '0760'
  } -> file { "${applications_location}/${environment}":
    ensure => 'directory',
    owner  => $applications_user,
    group => $applications_group,
    mode   => '0760'
  }

  group { $ssh_keys_group:
    ensure           => 'present'
  } -> user { $ssh_keys_user:
    ensure           => 'present',
    gid              => $ssh_keys_group,
    home             => "/home/${ssh_keys_user}",
    shell            => '/bin/bash'
  } -> file { "/home/${ssh_keys_user}":
    ensure => 'directory',
    owner  => $ssh_keys_user,
    mode   => '0750'
  }

  if ($sources_location)
  {
    file { $sources_location:
      ensure => 'directory',
      owner  => $anthill::applications_user,
      group  => $anthill::applications_group,
      mode   => '0760'
    }
  }

  if ($runtime_location)
  {
    file { $runtime_location:
      ensure => 'directory',
      owner  => $anthill::applications_user,
      group  => $anthill::applications_group,
      mode   => '0760'
    }
  }

  if ($tools_location)
  {
    file { $tools_location:
      ensure => 'directory',
      owner  => $anthill::applications_user,
      group  => $anthill::applications_group,
      mode   => '0760'
    }
  }

  if ($keys_location)
  {
    file { $keys_location:
      ensure => 'directory',
      owner  => $anthill::applications_user,
      group  => $anthill::applications_group,
      mode   => '0760'
    }
  }

  package { 'rsync': ensure => 'present' }
  package { 'curl': ensure => 'present' }
  package { 'build-essential': ensure => 'present' }
  package { 'libcurl4-openssl-dev': ensure => 'present' }
  package { 'libssl-dev': ensure => 'present' }
  package { 'libffi-dev': ensure => 'present' }
  package { 'ntp': ensure => 'present' }
  package { 'libreadline-dev': ensure => 'present' }
  package { 'libsqlite3-dev': ensure => 'present' }
  package { 'zlib1g-dev': ensure => 'present' }
  package { 'make': ensure => 'present' }
  package { 'python-pip': ensure => 'present' }

    if ($::operatingsystem == 'Debian' and $::operatingsystemmajrelease == '9') {
    $libmysqlclientdev_name = 'default-libmysqlclient-dev'
  } else {
    $libmysqlclientdev_name = 'libmysqlclient-dev'
  }

  package { $libmysqlclientdev_name: ensure => 'present' }
  package { 'apt-transport-https': ensure => 'present' }
}