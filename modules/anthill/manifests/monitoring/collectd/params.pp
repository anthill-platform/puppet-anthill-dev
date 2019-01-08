
class anthill::monitoring::collectd::params {

  $influxdb_location = "influxdb-${hostname}"
  $influxdb_collectd_port = 25826

  $report_memory = true
  $report_load = true
  $report_cpu = true
  $report_network = true
  $report_hard_drive = true
  $report_mysql = true
  $report_rabbitmq = true

  $report_mysql_db = "${environment}_collectd"
  $report_mysql_username = 'collectd'
  $report_mysql_password = 'anthill'

  $custom_types_db = "/etc/collectd/custom-types.db"

}