
class anthill::monitoring::collectd::plugins inherits anthill::monitoring::collectd {

  class { collectd::plugin::network:
    ensure => $ensure,
  }

  $influxdb = anthill::ensure_location("influxdb", $influxdb_location, true)

  $influxdb_host = $influxdb["host"]

  collectd::plugin::network::server { $influxdb_host:
    ensure => $ensure,
    port => $influxdb_collectd_port
  }

  class { collectd::plugin::memory:
    ensure => $report_memory ? { true => present, default => absent },
    valuesabsolute => false,
    valuespercentage => true
  }

  class { collectd::plugin::cpu:
    ensure => $report_cpu ? { true => present, default => absent },
    reportbystate => false,
    valuespercentage => true
  }

  class { collectd::plugin::load:
    ensure => $report_load ? { true => present, default => absent }
  }

  class { collectd::plugin::df:
    ensure => $report_hard_drive ? { true => present, default => absent },
    devices => [],
    fstypes => [],
    mountpoints => [],
    ignoreselected => true,
    valuespercentage => true
  }

  class { collectd::plugin::mysql:
    ensure => $report_mysql ? { true => present, default => absent },
    manage_package => true
  }

  if ($report_mysql) {

    if ! (defined(Class['anthill::mysql'])) {
      warning("MySQL Reporting is enabled, but no class { anthill::mysql: ... } enabled, skipping.")
    } else {
      $host = "%"

      mysql_user { "${report_mysql_username}@${host}":
        ensure                   => 'present',
        password_hash            => mysql_password($report_mysql_password),
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
        require => Package['mysql-server']
      } ->  mysql_grant { "${report_mysql_username}@${host}/*.*":
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['USAGE'],
        table      => "*.*",
        user       => "${report_mysql_username}@${host}",
        require => Package['mysql-server']
      } -> mysql_database { $report_mysql_db:
        ensure => 'present',
        charset => 'utf8'
      } -> collectd::plugin::mysql::database { $report_mysql_db:
        host        => anthill::local_ip_address(),
        username    => $report_mysql_username,
        password    => $report_mysql_password,
        port        => getparam(Class['anthill::mysql'], "listen_port"),
        masterstats => false,
        wsrepstats  => false
      }
    }
  }

  if ($report_rabbitmq)
  {
    if ! (defined(Class['anthill::rabbitmq'])) {
      warning("RabbitMQ Reporting is enabled, but no class { anthill::rabbitmq: ... } enabled, skipping.")
    } else {

      class { collectd::plugin::rabbitmq:
        config => {
          'Username' => $anthill::rabbitmq::admin_username,
          'Password' => $anthill::rabbitmq::admin_password,
          'Scheme'   => 'http',
          'Port'     => "${anthill::rabbitmq::admin_listen_port}",
          'Host'     => $anthill::rabbitmq::admin_listen_host,
          'Realm'    => '"RabbitMQ Management"',
        },
        # We need standard pip (2.7) to install collectd-rabbitmq into system
        manage_package => true
      }
    }
  }

}