
class anthill::monitoring::influxdb::params {

  include anthill

  $http_listen_host = anthill::local_ip_address()
  $http_listen_port = 8086

  $database_name = $environment

  $admin_username = 'admin'
  $admin_password = 'anthill'

  $application_username = 'anthill'
  $application_password = 'anthill'

  $grafana_location = "grafana-${hostname}"

  $listen_collectd = true
  $collectd_listen_host = anthill::local_ip_address()
  $collectd_listen_port = 25826

  $collectd_types_ensure = true
  $collectd_types_location = "/etc/influxdb/collectd-types.db"

}