class anthill::monitoring::grafana::mysql inherits anthill::monitoring::grafana {

  if ($manage_mysql_db) {
    if ! defined(Class['anthill::mysql']) {
      fail("class { anthill::mysql: } is required to manage database ")
    }

    mysql_database { $mysql_backend_db:
      ensure => $ensure,
      charset => 'utf8',
      tag => ["env-${environment}"]
    }
  }

  if ($manage_mysql_user) {

    $mysql_backend = anthill::ensure_location("mysql backend", $mysql_backend_location, true)

    $mysql_backend_host = $mysql_backend["host"]
    $mysql_backend_port = $mysql_backend["port"]

    if ! defined(Class['anthill::mysql']) {
      fail("class { anthill::mysql: } is required to manage user ")
    }

    mysql_user { "${mysql_backend_username}@${mysql_backend_host}":
      ensure                   => 'present',
      password_hash            => mysql_password($mysql_backend_password),
      max_connections_per_hour => '0',
      max_queries_per_hour     => '0',
      max_updates_per_hour     => '0',
      max_user_connections     => '0',
      require => Package['mysql-server']
    }

    mysql_grant { "${mysql_backend_username}@${mysql_backend_host}/*.*":
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      table      => "*.*",
      user       => "${mysql_backend_username}@${mysql_backend_host}",
      require => Package['mysql-server']
    }
  }


}