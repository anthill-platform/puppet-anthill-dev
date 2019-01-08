
class anthill::monitoring::influxdb::install inherits anthill::monitoring::influxdb {


  class { ::influxdb:
    ensure => $ensure,
    http_config => {
      "bind-address" => "${http_listen_host}:${http_listen_port}",
    },
    collectd_config => {
      "default" => {
        "enabled" => $listen_collectd,
        "bind-address" => "${collectd_listen_host}:${collectd_listen_port}",
        "database" => "${environment}",
        "parse-multivalue-plugin" => "join",
        "typesdb" => $collectd_types_location
      }
    },
    manage_repos => trueapt
  }

  if ($listen_collectd and $collectd_types_ensure) {
    file { $collectd_types_location:
      mode => '0644',
      ensure => 'present',
      owner => 'influxdb',
      group => 'influxdb',
      source => 'puppet:///modules/anthill/collectd/types.db',
      before => Service['influxdb'],
      require => Class['influxdb::config']
    }
  }

}