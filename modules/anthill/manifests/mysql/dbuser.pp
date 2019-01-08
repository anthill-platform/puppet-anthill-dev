
class anthill::mysql::dbuser {

  $host = "%"

  mysql_user { "${anthill::mysql::username}@${host}":
    ensure                   => 'present',
    password_hash            => mysql_password($anthill::mysql::password),
    max_connections_per_hour => '0',
    max_queries_per_hour     => '0',
    max_updates_per_hour     => '0',
    max_user_connections     => '0',
    require => Package['mysql-server']
  }

  mysql_grant { "${anthill::mysql::username}@${host}/*.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'CREATE', 'REFERENCES', 'EVENT', 'TRIGGER'],
    table      => "*.*",
    user       => "${anthill::mysql::username}@${host}",
    require => Package['mysql-server']
  }



}