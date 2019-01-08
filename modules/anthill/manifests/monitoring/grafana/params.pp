
class anthill::monitoring::grafana::params {

  $listen_host = anthill::local_ip_address()
  $listen_port = 8106

  $admin_username = 'admin'
  $admin_password = 'anthill'

  $mysql_backend_location = "mysql-${hostname}"
  $mysql_backend_username = 'grafana'
  $mysql_backend_password = ''
  $mysql_backend_db = "${environment}_grafana"

  $redis_backend_location = "redis-${hostname}"

  $manage_mysql_db = true
  $manage_mysql_user = true
}