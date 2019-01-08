
class anthill::mysql::install inherits anthill::mysql {

  # keep to mysql even on Debian 9
  class { ::mysql::client:
    package_name            => 'mysql-client'
  }

  class { ::mysql::server:
    package_name            => $mysql_package_name,
    package_ensure          => $mysql_package_version,
    root_password           => $root_password,
    remove_default_accounts => true,
    purge_conf_dir          => true,
    includedir              => '/etc/mysql/mysql.conf.d',
    restart                 => true,
    override_options        => {
      "mysqld" => {
        "event_scheduler" => "ON",
        "port"            => $listen_port,
        "bind-address"    => $anthill::internal_fqdn
      }
    },

    # keep to mysql even on Debian 9
    service_name            => 'mysql'
  }


  $client_package_name     = 'mysql-client'
  $server_package_name     = 'mysql-server'
  $server_service_name     = 'mysql'
  $client_dev_package_name = 'libmysqlclient-dev'
  $daemon_dev_package_name = 'libmysqld-dev'

  Apt::Source['mysql-5.7'] ~>
  Class['apt::update'] ->
  Class['::mysql::server']

}